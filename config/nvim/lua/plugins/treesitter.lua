local parsers = {
  "bash", "c", "cpp", "css", "diff", "dockerfile", "go", "html", "javascript", "json",
  "latex", "lua", "luadoc", "make", "markdown", "markdown_inline", "python",
  "query", "regex", "rust", "scss", "sql", "toml", "tsx", "typescript", "typst", "vim",
  "vimdoc", "yaml", "gitcommit", "git_rebase",
}

return {
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end },
}
