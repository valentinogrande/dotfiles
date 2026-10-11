-- Imágenes: se ven inline gracias a snacks.image (configurado en editor.lua)

-- Tamaños para <leader>is: ancho máximo en columnas, alto máximo en líneas
local sizes = {
  { name = "chico", w = 40, h = 15 },
  { name = "mediano", w = 80, h = 30 },
  { name = "grande", w = 120, h = 50 },
}
local current = 2

local function cycle_size()
  current = current % #sizes + 1
  local s = sizes[current]
  local doc = Snacks.image.config.doc
  doc.max_width, doc.max_height = s.w, s.h
  -- volver a dibujar las imágenes de los buffers abiertos con el tamaño nuevo
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.b[buf].snacks_image_attached then
      require("snacks.image.placement").clean(buf)
      vim.b[buf].snacks_image_attached = false
      Snacks.image.doc.attach(buf)
    end
  end
  vim.notify("Imágenes: " .. s.name, vim.log.levels.INFO, { title = "Snacks image" })
end

return {
  { "HakonHarnes/img-clip.nvim", event = "VeryLazy",
    opts = {
      default = {
        dir_path = "img",
        relative_to_current_file = true,
        file_name = "%Y%m%d-%H%M%S",
        prompt_for_file_name = false,
      },
    },
    keys = {
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Pegar imagen del portapapeles" },
      { "<leader>iv", function() Snacks.image.hover() end, desc = "Ver imagen bajo el cursor" },
      { "<leader>is", cycle_size, desc = "Tamaño de imágenes (chico/mediano/grande)" },
      { "<leader>ii", function()
          Snacks.picker.files({
            ft = { "png", "jpg", "jpeg", "gif", "webp", "bmp", "svg", "avif" },
            confirm = function(picker, item)
              picker:close()
              local file = vim.fn.fnamemodify(Snacks.picker.util.path(item), ":p")
              require("img-clip").paste_image({}, file)
            end,
          })
        end, desc = "Insertar imagen (archivo)" },
    } },
}
