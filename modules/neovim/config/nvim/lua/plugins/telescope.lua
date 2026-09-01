return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8", -- Menggunakan rilis versi stabil
    dependencies = {
      "nvim-lua/plenary.nvim", -- Dependency wajib Telescope & Neo-tree
      "nvim-tree/nvim-web-devicons", -- Ikon warna-warni untuk file
    },
    opts = {
      defaults = {
        path_display = { "smart" },
        file_ignore_patterns = { "node_modules", ".git/", "target/" },
      },
    },
    keys = {
      -- Shortcut Pencarian
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Cari Nama File)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Text (Cari Isi Teks/Ketik Kode)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers (File Terbuka)" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help (Dokumentasi)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find Recent Files (File Terakhir Buka)" },
    },
  },
}


