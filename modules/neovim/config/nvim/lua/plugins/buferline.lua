return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Diperlukan untuk ikon tipe file (VS Code style)
    },
    opts = {
      options = {
        mode = "buffers", -- Menampilkan buffer yang sedang dibuka sebagai tab
        separator_style = "slant", -- Gaya tab: "slant", "slope", "thick", atau "thin"
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,

        -- Membuat ruang di atas Neo-tree agar Tab tidak menutupi sidebar (VS Code style)
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },
    },
  },
}

