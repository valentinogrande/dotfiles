-- Atajos generales (los de cada plugin están en su archivo)
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "Guardar" })
map("n", "<leader>q", "<cmd>quitall<cr>", { desc = "Salir" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Guardar" })

-- Moverse entre ventanas
map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ventana abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ventana arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })

-- Buffers (como la bufferline de Helix: gn / gp)
map("n", "gn", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
map("n", "gp", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<leader>x", function() Snacks.bufdelete() end, { desc = "Cerrar buffer" })

-- Mover líneas seleccionadas
map("x", "J", ":m '>+1<cr>gv=gv", { desc = "Bajar selección" })
map("x", "K", ":m '<-2<cr>gv=gv", { desc = "Subir selección" })
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Diagnósticos
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = false }) end, { desc = "Diagnóstico siguiente" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = false }) end, { desc = "Diagnóstico anterior" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Documentación (hover)" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Activar/desactivar diagnósticos" })
map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Activar/desactivar inlay hints" })
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Activar/desactivar wrap" })
