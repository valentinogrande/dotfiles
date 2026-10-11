-- Muestra la corrección sugerida por LTeX+ al lado del error:
--   'herrores': posible error ortográfico → errores, horrores
-- LTeX+ manda las correcciones como code actions; acá se piden y se guardan por diagnóstico.
local M = {}
local cache = {} ---@type table<integer, table<string, string|false>>

local function key(d) return d.lnum .. ":" .. d.col .. ":" .. d.message end

local function replacements(actions)
  local out = {}
  for _, a in ipairs(actions or {}) do
    local edit = a.edit or {}
    for _, dc in ipairs(edit.documentChanges or {}) do
      for _, e in ipairs(dc.edits or {}) do table.insert(out, e.newText) end
    end
    for _, edits in pairs(edit.changes or {}) do
      for _, e in ipairs(edits) do table.insert(out, e.newText) end
    end
  end
  return out
end

local function fetch(buf, client)
  local ns = vim.lsp.diagnostic.get_namespace(client.id)
  local diags = vim.diagnostic.get(buf, { namespace = ns })
  local old, new = cache[buf] or {}, {}
  for _, d in ipairs(diags) do
    local k = key(d)
    new[k] = old[k]
    local lsp_d = d.user_data and d.user_data.lsp
    if new[k] == nil and lsp_d then
      new[k] = false
      client:request("textDocument/codeAction", {
        textDocument = vim.lsp.util.make_text_document_params(buf),
        range = lsp_d.range,
        context = { diagnostics = { lsp_d }, only = { "quickfix" } },
      }, function(err, actions)
        local sugs = err and {} or replacements(actions)
        if #sugs == 0 or not cache[buf] then return end
        cache[buf][k] = table.concat(vim.list_slice(sugs, 1, 3), ", ")
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then vim.diagnostic.show(ns, buf) end
        end)
      end, buf)
    end
  end
  cache[buf] = new
end

--- Aplica la primera corrección de cada error de LTeX+ entre las líneas first..last (0-indexed)
function M.autocorrect(buf, client, first, last)
  local ns = vim.lsp.diagnostic.get_namespace(client.id)
  local diags = vim.tbl_filter(function(d)
    return d.lnum >= first and d.lnum <= last and d.user_data and d.user_data.lsp
  end, vim.diagnostic.get(buf, { namespace = ns }))
  table.sort(diags, function(a, b) return a.lnum == b.lnum and a.col < b.col or a.lnum < b.lnum end)

  local edits, prev_end = {}, nil
  for _, d in ipairs(diags) do
    local lsp_d = d.user_data.lsp
    local res = client:request_sync("textDocument/codeAction", {
      textDocument = vim.lsp.util.make_text_document_params(buf),
      range = lsp_d.range,
      context = { diagnostics = { lsp_d }, only = { "quickfix" } },
    }, 3000, buf)
    for _, a in ipairs(res and res.result or {}) do
      local edit = a.edit or {}
      local e = (edit.documentChanges and edit.documentChanges[1] and edit.documentChanges[1].edits[1])
      if not e then
        for _, list in pairs(edit.changes or {}) do e = list[1]; break end
      end
      if e then
        -- saltear correcciones que se pisan con la anterior
        local s = e.range.start
        if not prev_end or s.line > prev_end.line or (s.line == prev_end.line and s.character >= prev_end.character) then
          table.insert(edits, e)
          prev_end = e.range["end"]
        end
        break
      end
    end
  end

  if #edits == 0 then return vim.notify("No hay nada para corregir") end
  vim.lsp.util.apply_text_edits(edits, buf, client.offset_encoding)
  vim.notify(("Corregidos %d errores"):format(#edits))
end

--- Para vim.diagnostic.config({ virtual_text = { format = ... } })
function M.format(d)
  local s = cache[d.bufnr] and cache[d.bufnr][key(d)]
  return s and (d.message .. " → " .. s) or d.message
end

-- Menú de <leader>a en archivos de texto: así no hay que acordarse de otras teclas
local function menu(buf, client)
  local visual = vim.fn.mode():match("[vV\22]")
  local a, b = vim.fn.line("v") - 1, vim.fn.line(".") - 1
  if visual then vim.cmd("normal! \27") end
  local first, last = math.min(a, b), math.max(a, b)
  local items = {
    { "Corregir este error (elegir sugerencia / agregar al diccionario)", function() vim.lsp.buf.code_action() end },
    { visual and "Corregir las líneas seleccionadas" or "Corregir toda la línea", function() M.autocorrect(buf, client, first, last) end },
    { "Corregir todo el archivo", function() M.autocorrect(buf, client, 0, vim.api.nvim_buf_line_count(buf)) end },
  }
  vim.ui.select(items, {
    prompt = "Corrector",
    format_item = function(i) return i[1] end,
  }, function(choice) if choice then choice[2]() end end)
end

function M.attach(client, buf)
  cache[buf] = cache[buf] or {}
  vim.b[buf].ltex = true
  vim.keymap.set({ "n", "x" }, "<leader>a", function() menu(buf, client) end, { buffer = buf, desc = "Corregir / acciones" })
  pcall(function() require("which-key").add({ { "<leader>c", group = "Corregir", buffer = buf } }) end)
  vim.keymap.set("n", "<leader>cl", function()
    local l = vim.fn.line(".") - 1
    M.autocorrect(buf, client, l, l)
  end, { buffer = buf, desc = "Corregir línea" })
  vim.keymap.set("x", "<leader>cl", function()
    local a, b = vim.fn.line("v") - 1, vim.fn.line(".") - 1
    vim.cmd("normal! \27")
    M.autocorrect(buf, client, math.min(a, b), math.max(a, b))
  end, { buffer = buf, desc = "Corregir selección" })
  vim.keymap.set("n", "<leader>cf", function()
    M.autocorrect(buf, client, 0, vim.api.nvim_buf_line_count(buf))
  end, { buffer = buf, desc = "Corregir todo el archivo" })
  local timer = assert(vim.uv.new_timer())
  local group = vim.api.nvim_create_augroup("ltex.suggestions." .. buf, { clear = true })
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = group,
    buffer = buf,
    callback = function()
      timer:stop()
      timer:start(300, 0, vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(buf) and not client:is_stopped() then fetch(buf, client) end
      end))
    end,
  })
  vim.api.nvim_create_autocmd({ "BufWipeout", "LspDetach" }, {
    group = group,
    buffer = buf,
    callback = function() cache[buf] = nil; timer:stop() end,
  })
end

return M
