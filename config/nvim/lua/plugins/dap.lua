-- Debugger: nvim-dap + interfaz. Rust (codelldb), C/C++ (codelldb), Python (debugpy), JS/TS (js-debug)
return {
  { "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, opts = {} },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: iniciar / continuar" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: siguiente línea" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: entrar" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: salir" },
      { "<leader>tb", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      { "<leader>tB", function() require("dap").set_breakpoint(vim.fn.input("Condición: ")) end, desc = "Breakpoint condicional" },
      { "<leader>tc", function() require("dap").continue() end, desc = "Iniciar / continuar" },
      { "<leader>tC", function() require("dap").run_to_cursor() end, desc = "Correr hasta el cursor" },
      { "<leader>tn", function() require("dap").step_over() end, desc = "Siguiente línea" },
      { "<leader>ti", function() require("dap").step_into() end, desc = "Entrar" },
      { "<leader>to", function() require("dap").step_out() end, desc = "Salir" },
      { "<leader>tl", function() require("dap").run_last() end, desc = "Repetir última sesión" },
      { "<leader>tr", function() require("dap").repl.toggle() end, desc = "REPL" },
      { "<leader>tq", function() require("dap").terminate() end, desc = "Terminar" },
      { "<leader>tu", function() require("dapui").toggle() end, desc = "Interfaz del debugger" },
      { "<leader>te", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "Evaluar expresión" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      local mason = vim.fn.stdpath("data") .. "/mason"

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

      -- Abrir/cerrar la interfaz sola
      dap.listeners.after.event_initialized.dapui = dapui.open
      dap.listeners.before.event_terminated.dapui = dapui.close
      dap.listeners.before.event_exited.dapui = dapui.close

      -- C / C++ (Rust lo configura rustaceanvim)
      dap.adapters.codelldb = {
        type = "server", port = "${port}",
        executable = { command = mason .. "/bin/codelldb", args = { "--port", "${port}" } },
      }
      dap.configurations.c = {
        { name = "Ejecutar binario", type = "codelldb", request = "launch", cwd = "${workspaceFolder}",
          program = function() return vim.fn.input("Binario: ", vim.fn.getcwd() .. "/", "file") end,
          args = function() return vim.split(vim.fn.input("Argumentos: "), " ", { trimempty = true }) end },
      }
      dap.configurations.cpp = dap.configurations.c

      -- Python
      require("dap-python").setup(mason .. "/packages/debugpy/venv/bin/python")

      -- JavaScript / TypeScript (Node)
      dap.adapters["pwa-node"] = {
        type = "server", host = "localhost", port = "${port}",
        executable = { command = mason .. "/bin/js-debug-adapter", args = { "${port}" } },
      }
      for _, ft in ipairs({ "javascript", "typescript" }) do
        dap.configurations[ft] = {
          { type = "pwa-node", request = "launch", name = "Ejecutar archivo actual",
            program = "${file}", cwd = "${workspaceFolder}", sourceMaps = true },
          { type = "pwa-node", request = "attach", name = "Conectar a proceso",
            processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
        }
      end
    end },
}
