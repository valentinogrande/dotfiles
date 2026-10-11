local au = vim.api.nvim_create_autocmd

-- Guardar al perder el foco (auto-save de Helix)
au({ "FocusLost", "BufLeave" }, { command = "silent! wall" })

-- Resaltar lo copiado
au("TextYankPost", { callback = function() vim.hl.on_yank({ timeout = 150 }) end })

-- Volver a la última posición al abrir un archivo
au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 4 espacios en lenguajes que lo usan por convención
au("FileType", {
  pattern = { "python", "rust", "c", "cpp", "go", "sql" },
  callback = function() vim.bo.shiftwidth = 4; vim.bo.tabstop = 4 end,
})
