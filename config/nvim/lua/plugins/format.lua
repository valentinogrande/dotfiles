-- Formatear al guardar (auto-format de Helix). <leader>uf lo activa/desactiva.
return {
  { "stevearc/conform.nvim", event = "BufWritePre", cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        sql = { "sql_formatter" },
        toml = { "taplo" },
      },
      format_on_save = function(buf)
        if vim.g.autoformat == false or vim.b[buf].autoformat == false then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
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
