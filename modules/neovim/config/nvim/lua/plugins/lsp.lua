return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup() -- setup mason

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      -- Ambil kapabilitas autocomplete dari cmp-nvim-lsp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim-lsp")
      if cmp_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- Konfigurasi LSP Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
     vim.lsp.enable("lua_ls")

		 -- Konfigurasi LSP Nix
		 vim.lsp.config("nixd", {
        capabilities = capabilities,
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })
      vim.lsp.enable("nixd")

      -- Keymaps LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
}
