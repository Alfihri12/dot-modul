return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Kecepatan popup muncul (dalam milidetik)
      delay = 200,
      
      -- Mengelompokkan grup shortcut agar menu popup terlihat rapi
      spec = {
        { "<leader>w", group = "Window / Save" },
        { "<leader>q", group = "Quit" },
        { "<leader>b", group = "Buffers" },
        { "<leader>t", group = "Terminal" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (Which-key)",
      },
    },
  },
}




