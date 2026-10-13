-- LSP: usa los servidores del sistema (los mismos que Helix) y Mason para los que faltan.
-- Rust lo maneja rustaceanvim (rust.lua) y Cargo.toml crates.nvim.

-- Diccionario propio para el corrector (LTeX+), en los dotfiles
local dict_file = vim.fn.stdpath("config") .. "/spell/es.utf-8.add"
local function dict_words()
  return vim.uv.fs_stat(dict_file) and vim.fn.readfile(dict_file) or {}
end

local servers = {
  pyright = {},
  ruff = {},
  ts_ls = {},
  clangd = { cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" } },
  bashls = {},
  sqls = {},
  taplo = {},
  marksman = {},
  -- Corrector de ortografía y gramática en español (LanguageTool)
  ltex_plus = {
    filetypes = { "markdown", "typst", "tex", "text" },
    -- usa el Java 21 que trae el paquete (el del sistema es más viejo)
    cmd_env = {
      JAVA_HOME = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/ltex-ls-plus/*/jdk-*", false, true)[1],
    },
    settings = {
      ltex = {
        language = "es",
        additionalRules = { motherTongue = "es" },
        dictionary = { es = dict_words() },
        -- el "!" de los callouts de markdown (> [!TIP], > [!NOTE]...) lo toma como fin de oración
        disabledRules = { es = { "ESPACIO_DESPUES_DE_PUNTO" } },
        -- como "warning" para que se vean inline (por defecto son "information")
        diagnosticSeverity = "warning",
      },
    },
    on_attach = function(client, buf) require("config.ltex").attach(client, buf) end,
  },
  -- Inglés: solo mensajes de commit
  harper_ls = {
    filetypes = { "gitcommit" },
    settings = { ["harper-ls"] = { dialect = "American" } },
  },
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = "Replace" }, hint = { enable = true } } },
  },
  jsonls = {},
  html = {},
  cssls = {},
  yamlls = {},
  tinymist = {},
  gopls = {},
  texlab = {},
}

-- Herramientas que no estaban instaladas en el sistema
local mason_tools = {
  "lua-language-server", "json-lsp", "html-lsp", "css-lsp", "yaml-language-server",
  "tinymist", "ruff", "stylua", "shfmt", "prettierd", "sql-formatter",
  "debugpy", "codelldb", "js-debug-adapter", "ltex-ls-plus",
}

return {
  { "mason-org/mason.nvim", lazy = false, opts = { ui = { border = "rounded" } } },

  { "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = mason_tools, run_on_start = true, start_delay = 3000, debounce_hours = 24 } },

  { "folke/lazydev.nvim", ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, "snacks.nvim" } } },

  { "neovim/nvim-lspconfig", lazy = false,
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
        local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
        if type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1 then
          vim.lsp.enable(name)
        end
      end

      -- "Agregar al diccionario" de LTeX+ guarda la palabra en el archivo (si no, se pierde al cerrar)
      vim.lsp.commands["_ltex.addToDictionary"] = function(cmd, ctx)
        local new = {}
        for _, words in pairs(cmd.arguments[1].words) do vim.list_extend(new, words) end
        vim.fn.mkdir(vim.fn.fnamemodify(dict_file, ":h"), "p")
        vim.fn.writefile(new, dict_file, "a")
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
          client.settings.ltex.dictionary = { es = dict_words() }
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end
        vim.notify("Agregado al diccionario: " .. table.concat(new, ", "))
      end

      -- Sacar los gr* por defecto de Neovim para que gr = referencias, como en Helix
      for _, k in ipairs({ "grn", "gra", "grr", "gri", "grt" }) do pcall(vim.keymap.del, "n", k) end
      pcall(vim.keymap.del, "x", "gra")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          local P = Snacks.picker
          map("gd", P.lsp_definitions, "Ir a definición")
          map("gD", P.lsp_declarations, "Ir a declaración")
          map("gr", P.lsp_references, "Referencias")
          map("gi", P.lsp_implementations, "Implementaciones")
          map("gy", P.lsp_type_definitions, "Definición del tipo")
          map("<leader>s", P.lsp_symbols, "Símbolos del archivo")
          map("<leader>S", P.lsp_workspace_symbols, "Símbolos del proyecto")
          -- en archivos de texto <leader>a es el menú del corrector (config/ltex.lua)
          if not vim.b[ev.buf].ltex then
            map("<leader>a", vim.lsp.buf.code_action, "Acciones de código", { "n", "x" })
          end
          map("<leader>r", vim.lsp.buf.rename, "Renombrar")
          map("<leader>h", vim.lsp.buf.signature_help, "Firma de la función")
          map("<C-k>", vim.lsp.buf.signature_help, "Firma de la función", "i")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })
    end },
}
