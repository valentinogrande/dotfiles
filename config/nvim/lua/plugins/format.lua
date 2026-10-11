-- Formatear después de guardar, en segundo plano (no traba el editor). <leader>uf lo activa/desactiva.
return {
  { "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" }, cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        sql = { "sql_formatter" },
        toml = { "taplo" },
      },
      format_after_save = function(buf)
        if vim.g.autosaving or vim.g.autoformat == false or vim.b[buf].autoformat == false then return end
        return { lsp_format = "fallback" }
      end,
    },
    keys = {
      { "<leader>=", function() require("conform").format({ lsp_format = "fallback" }) end, mode = { "n", "x" }, desc = "Formatear" },
      { "<leader>uf", function()
          vim.g.autoformat = vim.g.autoformat == false
          vim.notify("Formato al guardar: " .. (vim.g.autoformat and "activado" or "desactivado"))
        end, desc = "Activar/desactivar formato al guardar" },
    } },
}
