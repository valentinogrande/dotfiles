-- Edición potente: saltos, multicursor, objetos de texto por sintaxis
return {
  -- s + 2 letras para saltar a cualquier lugar visible; S selecciona nodos de sintaxis
  { "folke/flash.nvim", event = "VeryLazy", opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Saltar (flash)" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Seleccionar por sintaxis" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Operar a distancia" },
    } },

  -- Multicursor
  { "jake-stewart/multicursor.nvim", branch = "1.0", event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Cursor en la próxima coincidencia" })
      set({ "n", "x" }, "<C-p>", function() mc.matchSkipCursor(1) end, { desc = "Saltear coincidencia" })
      set({ "n", "x" }, "<leader>M", mc.matchAllAddCursors, { desc = "Cursor en todas las coincidencias" })
      set({ "n", "x" }, "<C-Up>", function() mc.lineAddCursor(-1) end, { desc = "Cursor arriba" })
      set({ "n", "x" }, "<C-Down>", function() mc.lineAddCursor(1) end, { desc = "Cursor abajo" })
      set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Cursor con el mouse" })
      set("x", "I", mc.insertVisual, { desc = "Insertar en cada línea" })
      set("x", "A", mc.appendVisual, { desc = "Agregar al final de cada línea" })
      mc.addKeymapLayer(function(layer)
        layer({ "n", "x" }, "<Left>", mc.prevCursor)
        layer({ "n", "x" }, "<Right>", mc.nextCursor)
        layer({ "n", "x" }, "<leader>x", mc.deleteCursor)
        layer("n", "<Esc>", function()
          if not mc.cursorsEnabled() then mc.enableCursors() else mc.clearCursors() end
        end)
      end)
    end },

  -- Objetos de texto: vaf/dif (función), vac/dic (clase), vio (bloque), cia (argumento)...
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
      local move = require("nvim-treesitter-textobjects.move")
      local map = function(k, fn, q, d)
        vim.keymap.set({ "n", "x", "o" }, k, function() move[fn](q, "textobjects") end, { desc = d })
      end
      map("]f", "goto_next_start", "@function.outer", "Función siguiente")
      map("[f", "goto_previous_start", "@function.outer", "Función anterior")
      map("]k", "goto_next_start", "@class.outer", "Clase siguiente")
      map("[k", "goto_previous_start", "@class.outer", "Clase anterior")
      map("]a", "goto_next_start", "@parameter.inner", "Argumento siguiente")
      map("[a", "goto_previous_start", "@parameter.inner", "Argumento anterior")
    end },
  { "nvim-mini/mini.ai", event = "VeryLazy", dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      })
    end },

  -- Muestra la firma de la función/clase arriba cuando scrolleás
  { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy", opts = { max_lines = 3 } },

  -- Cierra/renombra tags HTML/JSX automáticamente
  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },

  -- Detecta tabs/espacios de cada archivo
  { "NMAC427/guess-indent.nvim", event = "BufReadPre", opts = {} },

  -- Resalta TODO/FIXME/HACK/NOTE
  { "folke/todo-comments.nvim", event = "VeryLazy", dependencies = { "nvim-lua/plenary.nvim" }, opts = {},
    keys = {
      { "<leader>ot", function() Snacks.picker.todo_comments() end, desc = "TODOs del proyecto" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "TODO siguiente" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "TODO anterior" },
    } },
}
