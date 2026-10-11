-- Herramientas: tests, diffs de git, sesiones, buscar y reemplazar en el proyecto
return {
  { "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "nvim-neotest/neotest-python" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("rustaceanvim.neotest"),
          require("neotest-python")({ dap = { justMyCode = false } }),
        },
      })
    end,
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end, desc = "Correr test bajo el cursor" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Correr tests del archivo" },
      { "<leader>Ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Correr todos los tests" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Repetir último" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Depurar test" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Resumen" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end, desc = "Ver salida" },
      { "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Re-correr al guardar" },
    } },

  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Ver cambios (diff)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Historial del archivo" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Cerrar diff" },
    } },

  { "folke/persistence.nvim", event = "BufReadPre", opts = {},
    keys = {
      { "<leader>os", function() require("persistence").load() end, desc = "Restaurar sesión de esta carpeta" },
      { "<leader>oS", function() require("persistence").select() end, desc = "Elegir sesión" },
    } },

  { "MagicDuck/grug-far.nvim", cmd = "GrugFar", opts = {},
    keys = {
      { "<leader>oR", function() require("grug-far").open() end, mode = { "n", "x" }, desc = "Buscar y reemplazar en el proyecto" },
    } },
}
