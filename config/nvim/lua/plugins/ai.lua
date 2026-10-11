-- Claude Code dentro de Neovim: ve tu selección y archivo, y propone cambios como diffs
return {
  { "coder/claudecode.nvim", dependencies = { "folke/snacks.nvim" }, opts = {},
    keys = {
      { "<leader>Ac", "<cmd>ClaudeCode<cr>", desc = "Abrir/cerrar Claude" },
      { "<leader>Af", "<cmd>ClaudeCodeFocus<cr>", desc = "Ir a Claude" },
      { "<leader>Ar", "<cmd>ClaudeCode --resume<cr>", desc = "Retomar conversación" },
      { "<leader>Ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Mandar archivo actual" },
      { "<leader>As", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Mandar selección" },
      { "<leader>Aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Aceptar cambio" },
      { "<leader>Ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Rechazar cambio" },
    } },
}
