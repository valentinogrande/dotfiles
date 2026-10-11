local o = vim.opt
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorcolumn = true
o.colorcolumn = "80,120"
o.mouse = "a"
o.termguicolors = true
o.wrap = true
o.linebreak = true
o.breakindent = true
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.undofile = true
o.signcolumn = "yes"
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.splitright = true
o.splitbelow = true
o.scrolloff = 5
o.updatetime = 50
o.timeoutlen = 300
o.showmode = false -- el modo lo muestra la statusline
o.laststatus = 3
o.confirm = true
o.list = true
o.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.completeopt = "menu,menuone,noselect"
o.winborder = "rounded"

-- Diagnósticos como en Helix: errores inline en todas las líneas,
-- el detalle completo solo en la línea del cursor.
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 2, prefix = "●" },
  virtual_lines = { current_line = true },
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.INFO] = "■",
      [vim.diagnostic.severity.HINT] = "◆",
    },
  },
})
