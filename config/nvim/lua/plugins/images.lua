-- Imágenes: se ven inline gracias a snacks.image (configurado en editor.lua)
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
