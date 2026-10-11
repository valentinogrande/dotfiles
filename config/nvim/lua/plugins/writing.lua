-- Escritura: Markdown renderizado y preview de Typst
return {
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = { completions = { blink = { enabled = true } } },
    keys = { { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Activar/desactivar Markdown renderizado" } } },

  { "chomosuke/typst-preview.nvim", ft = "typst", version = "1.*",
    opts = { dependencies_bin = { tinymist = "tinymist" } },
    keys = { { "<leader>cp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Preview de Typst en el navegador" } } },
}
