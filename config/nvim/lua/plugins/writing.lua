-- Escritura: Markdown renderizado y preview de Typst

-- La terminal no puede cambiar el tamaño de letra, así que los títulos se
-- distinguen por peso visual: # franja sólida, ## franja suave, ### bloque, resto solo color
local function heading_colors()
  local hex = function(n) return string.format("#%06x", n) end
  local function blend(fg, bg, a)
    local f, b = tonumber(fg:sub(2), 16), tonumber(bg:sub(2), 16)
    local c = function(s) return math.floor(bit.band(bit.rshift(f, s), 255) * a + bit.band(bit.rshift(b, s), 255) * (1 - a) + 0.5) end
    return string.format("#%02x%02x%02x", c(16), c(8), c(0))
  end
  local bg = hex(vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0x1a1b26)
  local alpha = { 1, 0.35, 0.18 }
  for i = 1, 6 do
    local fg = hex(vim.api.nvim_get_hl(0, { name = "RenderMarkdownH" .. i, link = false }).fg or 0xc0caf5)
    if i == 1 then
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = bg, bg = fg, bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = bg, bg = fg, bold = true })
    elseif alpha[i] then
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = blend(fg, bg, alpha[i]) })
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bg = blend(fg, bg, alpha[i]), bold = true })
    else
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", {})
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bold = true })
    end
  end
end

return {
  -- Sin `ft`: el plugin ya se activa solo en markdown, y cargarlo por ft re-dispara
  -- FileType y el undo_ftplugin del runtime tira E31 (nunmap de un map inexistente)
  { "MeanderingProgrammer/render-markdown.nvim", lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      completions = { blink = { enabled = true } },
      heading = {
        width = { "full", "full", "block" },
        left_pad = { 0, 0, 1, 0 },
        right_pad = { 0, 0, 2, 0 },
        border = { true, true, false },
        border_virtual = true,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      heading_colors()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = heading_colors })
    end,
    keys = { { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Activar/desactivar Markdown renderizado" } } },

  { "chomosuke/typst-preview.nvim", ft = "typst", version = "1.*",
    opts = { dependencies_bin = { tinymist = "tinymist" } },
    keys = { { "<leader>cp", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Preview de Typst en el navegador" } } },
}
