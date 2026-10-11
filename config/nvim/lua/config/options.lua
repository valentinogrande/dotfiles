local o = vim.opt
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorcolumn = false
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
o.redrawtime = 1500
o.synmaxcol = 300
o.updatetime = 250
o.timeoutlen = 300
o.showmode = false -- el modo lo muestra la statusline
o.laststatus = 3
o.confirm = true
o.list = true
o.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.completeopt = "menu,menuone,noselect"
o.winborder = "rounded"

-- Diagnósticos: errores y warnings inline; el detalle completo con <leader>k o gl
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    spacing = 2,
    prefix = "●",
    format = function(d) return require("config.ltex").format(d) end,
  },
  virtual_lines = false,
  float = { border = "rounded", source = true, format = function(d) return require("config.ltex").format(d) end },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.INFO] = "■",
      [vim.diagnostic.severity.HINT] = "◆",
    },
  },
})
