local au = vim.api.nvim_create_autocmd

-- Guardar al perder el foco (auto-save de Helix)
au("FocusLost", {
  callback = function()
    vim.g.autosaving = true
    vim.cmd("silent! wall")
    vim.g.autosaving = false
  end,
})

-- Resaltar lo copiado
au("TextYankPost", { callback = function() vim.hl.on_yank({ timeout = 150 }) end })

-- Volver a la última posición al abrir un archivo
au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 4 espacios en lenguajes que lo usan por convención
au("FileType", {
  pattern = { "python", "rust", "c", "cpp", "go", "sql" },
  callback = function() vim.bo.shiftwidth = 4; vim.bo.tabstop = 4 end,
})

-- Actualizar el índice de marksman al guardar (solo si el archivo ya tiene <!--toc:start-->)
au("BufWritePre", {
  pattern = "*.md",
  callback = function(ev)
    local client = vim.lsp.get_clients({ bufnr = ev.buf, name = "marksman" })[1]
    if not client then return end
    local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    if not vim.iter(lines):any(function(l) return l:find("<!--toc:start-->", 1, true) end) then return end

    local res = client:request_sync("textDocument/codeAction", {
      textDocument = vim.lsp.util.make_text_document_params(ev.buf),
      range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 0 } },
      context = { diagnostics = {} },
    }, 2000, ev.buf)
    for _, a in ipairs(res and res.result or {}) do
      if a.title:find("Table of Contents") and a.edit then
        vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding)
        return
      end
    end
  end,
})
