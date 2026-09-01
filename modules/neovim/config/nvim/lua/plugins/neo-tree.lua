return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true, -- tutup neovim jika tersisa neo-tree saja
      window = {
        position = "left", -- posisi di sebelah kiri
        width = 30,
        mappings = {["<CR>"] = "open", ["l"] = "open", ["h"] = "close_node",},
      },
      filesystem = {
        filtered_items = {
          visible = true, -- tampilkan hidden files (dotfiles)
          hide_dotfiles = false,
          hide_gitignored = false,
        },
				bind_to_cwd = true, -- neo-tree mengikuti folder terminal
        follow_current_file = {
          enabled = true, -- otomatis sorot file yang sedang dibuka
					leave_dirs_open = false,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      -- Shortcut untuk toggle/membuka Neo-tree di sebelah kiri
      { "<leader>e", "<cmd>Neotree toggle left<CR>", desc = "Toggle Neo-tree" },
    },
  },
}
