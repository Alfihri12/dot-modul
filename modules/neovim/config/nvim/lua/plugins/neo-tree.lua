return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "float",
        width = 30,
        mappings = {
          ["<CR>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
        }
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", 
    },
    lazy = false,
  }
}





