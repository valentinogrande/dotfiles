return {
  { "folke/snacks.nvim", lazy = false, priority = 1000,
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
      zen = { enabled = true },
      scratch = { enabled = true },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = { hidden = true },
          -- Explorador flotante como el espacio+e de Helix:
          -- con preview y se cierra al abrir un archivo
          explorer = {
            hidden = true,
            auto_close = true,
            jump = { close = true },
            layout = { preset = "default", preview = true },
          },
        },
      },
      image = {
        enabled = true,
        -- Sin dibujo automático: se prenden con <leader>im (ver images.lua)
        doc = { inline = false, float = false, max_width = 80, max_height = 30 },
      },
    },
    keys = {
      -- Igual que el menú espacio de Helix
      { "<leader>f", function() Snacks.picker.files() end, desc = "Buscar archivo" },
      { "<leader>F", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Buscar archivo (carpeta actual)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Buscar texto en el proyecto" },
      { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers abiertos" },
      { "<leader>'", function() Snacks.picker.resume() end, desc = "Reabrir último buscador" },
      { "<leader>j", function() Snacks.picker.jumps() end, desc = "Saltos" },
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorador (proyecto)" },
      { "<leader>E", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Explorador (carpeta del archivo)" },
      { "<leader>d", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnósticos del archivo" },
      { "<leader>D", function() Snacks.picker.diagnostics() end, desc = "Diagnósticos del proyecto" },
      { "<leader>ok", function() Snacks.picker.keymaps() end, desc = "Todos los atajos" },
      { "<leader>oh", function() Snacks.picker.help() end, desc = "Ayuda" },
      { "<leader>or", function() Snacks.picker.recent() end, desc = "Archivos recientes" },
      { "<leader>oc", function() Snacks.picker.colorschemes() end, desc = "Temas" },
      { "<leader>on", function() Snacks.notifier.show_history() end, desc = "Notificaciones" },
      { "<leader>ou", function() Snacks.picker.undo() end, desc = "Historial de cambios (undo)" },
      { "<leader>z", function() Snacks.zen() end, desc = "Modo zen" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Nota rápida (scratch)" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame de la línea" },
      { "<C-g>", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<C-y>", function() Snacks.terminal("yazi") end, desc = "Yazi" },
      { "<C-/>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Terminal" },
      { "]]", function() Snacks.words.jump(1) end, desc = "Siguiente referencia" },
      { "[[", function() Snacks.words.jump(-1) end, desc = "Referencia anterior" },
    } },

  -- Cambios de git en el margen (como el gutter "diff" de Helix)
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = buf, desc = d }) end
        map("]g", function() gs.nav_hunk("next") end, "Cambio siguiente")
        map("[g", function() gs.nav_hunk("prev") end, "Cambio anterior")
        map("<leader>gp", gs.preview_hunk, "Ver cambio")
        map("<leader>gr", gs.reset_hunk, "Deshacer cambio")
      end,
    } },

  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },
  { "nvim-mini/mini.surround", event = "VeryLazy",
    opts = { mappings = { add = "gsa", delete = "gsd", replace = "gsr", find = "gsf", find_left = "gsF", highlight = "gsh", update_n_lines = "gsn" } } },
}
