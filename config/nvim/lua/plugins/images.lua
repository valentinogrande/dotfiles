-- Imágenes: snacks.image (configurado en editor.lua) con el modo automático
-- apagado; se prenden/apagan a mano por buffer con <leader>im / <leader>ia.

-- Tamaños para <leader>is: ancho máximo en columnas, alto máximo en líneas
local sizes = {
  { name = "chico", w = 40, h = 15 },
  { name = "mediano", w = 80, h = 30 },
  { name = "grande", w = 120, h = 50 },
}
local current = 2

local function images_off(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  require("snacks.image.placement").clean(buf)
  vim.b[buf].images_on = false
end

-- Dibuja inline todas las imágenes del archivo, no solo las visibles
local function images_on(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  images_off(buf)
  Snacks.image.doc.find(buf, function(imgs)
    for _, i in ipairs(imgs) do
      Snacks.image.placement.new(buf, i.src, Snacks.config.merge({}, Snacks.image.config.doc, {
        pos = i.pos,
        range = i.range,
        inline = true,
        type = i.type,
      }))
    end
    vim.b[buf].images_on = true
    vim.notify(#imgs .. " imágenes", vim.log.levels.INFO, { title = "Snacks image" })
  end)
end

local function cycle_size()
  current = current % #sizes + 1
  local s = sizes[current]
  local doc = Snacks.image.config.doc
  doc.max_width, doc.max_height = s.w, s.h
  -- volver a dibujar las imágenes prendidas con el tamaño nuevo
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.b[buf].images_on then
      images_on(buf)
    end
  end
  vim.notify("Imágenes: " .. s.name, vim.log.levels.INFO, { title = "Snacks image" })
end

vim.api.nvim_create_user_command("ImagesOn", function() images_on() end, { desc = "Mostrar todas las imágenes del archivo" })
vim.api.nvim_create_user_command("ImagesOff", function() images_off() end, { desc = "Apagar las imágenes del archivo" })

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
      { "<leader>im", function() images_on() end, desc = "Mostrar todas las imágenes del archivo" },
      { "<leader>ia", function() images_off() end, desc = "Apagar imágenes del archivo" },
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
