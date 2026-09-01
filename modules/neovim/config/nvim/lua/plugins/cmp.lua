return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Load saat mulai mengetik
    dependencies = {
      -- Sumber saran (completion sources)
      "hrsh7th/cmp-nvim-lsp", -- Saran dari LSP (bahasa pemrograman)
      "hrsh7th/cmp-buffer",   -- Saran dari kata di buffer aktif
      "hrsh7th/cmp-path",     -- Saran path/lokasi file
      "saadparwaiz1/cmp_luasnip",

      -- Engine Snippet (diperlukan nvim-cmp)
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets", -- Koleksi snippet ala VS Code
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load snippet ala VS Code (html, js, python, lua, dll)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- Navigasi daftar saran (panah atas/bawah)
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Buka/Tutup menu autocomplete secara manual
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),

          -- Tekan Enter untuk mengonfirmasi pilihan saran
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tombol Tab (Perilaku ala VS Code)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Urutan sumber rekomendasi yang muncul
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
