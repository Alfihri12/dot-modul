local autocmd = vim.api.nvim_create_autocmd

-- Otomatis highlight teks saat di-yank (copy)
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Hilangkan baris komentar otomatis saat buat baris baru di file Python
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Hapus spasi kosong berlebih di akhir baris secara otomatis sebelum file disimpan
autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/\\s\\+$//e",
})


