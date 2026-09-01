return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Plugin baru di-load saat kamu mulai masuk mode mengetik (Insert Mode)
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true, -- Integrasi dengan Treesitter (mencegah auto-pair di dalam komentar/string)
      })

      -- Integrasi dengan nvim-cmp (Jika kamu pakai nvim-cmp untuk auto-complete)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}


