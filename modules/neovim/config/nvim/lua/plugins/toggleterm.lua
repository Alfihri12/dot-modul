return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<c-\>]], -- Tombol pintas default: Ctrl + \
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float", -- Pilihan: "float", "horizontal", "vertical", "tab"
      close_on_exit = true,
      shell = vim.o.shell,
      dir = "%:p:h", -- Otomatis mengarahkan ke folder tempat file aktif berada
      float_opts = {
        border = "curved", -- Bingkai melayang lengkung
      },
    },
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float dir=%:p:h<cr>", desc = "Terminal Floating (Current File Dir)" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal dir=%:p:h<cr>", desc = "Terminal Horizontal (Current File Dir)" },
    },
  },
}

