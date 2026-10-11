-- Apariencia: tema y barras parecidos a tu Helix (tokyonight)
return {
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    opts = { style = "night", styles = { comments = { italic = true } } },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end },

  -- Statusline como la de Helix: modo | archivo · git · diagnósticos, posición, encoding, tipo
  { "nvim-lualine/lualine.nvim", event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = "│",
        section_separators = "",
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return s:sub(1, 6) end } },
        lualine_b = { { "filename", path = 1, symbols = { modified = "[+]", readonly = "[RO]" } } },
        lualine_c = { "%=", "branch" },
        lualine_x = { "diagnostics", { "selectioncount" }, "location" },
        lualine_y = { "progress", "encoding" },
        lualine_z = { "filetype" },
      },
    } },

  -- Pestañas de buffers solo cuando hay más de uno (bufferline = "multiple")
  { "akinsho/bufferline.nvim", version = "*", event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        close_command = function(n) Snacks.bufdelete(n) end,
      },
    } },

  -- El "programita" que muestra qué hace cada tecla
  { "folke/which-key.nvim", event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 200,
      spec = {
        { "<leader>t", group = "Debugger" },
        { "<leader>g", group = "Git" },
        { "<leader>i", group = "Imágenes" },
        { "<leader>o", group = "Otros buscadores" },
        { "<leader>u", group = "Activar/desactivar" },
        { "<leader>c", group = "Código / Crates" },
        { "<leader>R", group = "Rust" },
      },
    },
    keys = {
      { "<leader>?", function() Snacks.picker.keymaps() end, desc = "Paleta: todas las acciones y sus teclas" },
      { "<leader>:", function() Snacks.picker.commands() end, desc = "Paleta: todos los comandos" },
      { "<leader>ow", function() require("which-key").show({ global = false }) end, desc = "Atajos de este buffer" },
    } },
}
