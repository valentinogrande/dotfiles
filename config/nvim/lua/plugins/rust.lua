-- Rust: rustaceanvim (rust-analyzer + clippy + debugger) y crates.nvim para Cargo.toml
return {
  { "mrcjkb/rustaceanvim", version = "*", lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              cargo = { allFeatures = true },
              procMacro = { enable = true },
            },
          },
          on_attach = function(_, buf)
            local map = function(l, cmd, d) vim.keymap.set("n", l, function() vim.cmd.RustLsp(cmd) end, { buffer = buf, desc = d }) end
            map("<leader>a", "codeAction", "Acciones de código (Rust)")
            map("<leader>Rr", "runnables", "Ejecutar (runnables)")
            map("<leader>Rt", "testables", "Tests")
            map("<leader>Rd", "debuggables", "Depurar")
            map("<leader>Re", "expandMacro", "Expandir macro")
            map("<leader>Rc", "openCargo", "Abrir Cargo.toml")
            map("<leader>Rp", "parentModule", "Módulo padre")
            map("<leader>Rx", "explainError", "Explicar error")
            map("<leader>Rk", { "hover", "actions" }, "Hover con acciones")
            map("J", "joinLines", "Unir líneas")
          end,
        },
      }
    end },

  { "saecki/crates.nvim", event = "BufRead Cargo.toml",
    opts = {
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      completion = { crates = { enabled = true } },
      popup = { border = "rounded" },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function(ev)
          local map = function(l, f, d) vim.keymap.set("n", l, f, { buffer = ev.buf, desc = d }) end
          map("<leader>cu", crates.upgrade_crate, "Actualizar crate")
          map("<leader>cU", crates.upgrade_all_crates, "Actualizar todos los crates")
          map("<leader>cv", crates.show_versions_popup, "Ver versiones")
          map("<leader>cf", crates.show_features_popup, "Ver features")
          map("<leader>cd", crates.show_dependencies_popup, "Ver dependencias")
          map("<leader>cD", crates.open_documentation, "Abrir docs.rs")
          map("<leader>cc", crates.open_crates_io, "Abrir crates.io")
        end,
      })
      vim.cmd("doautocmd BufRead Cargo.toml")
    end },
}
