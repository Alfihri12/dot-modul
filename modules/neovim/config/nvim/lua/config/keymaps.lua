-----------------------------------------------------------
-- Keymaps Config (~/.config/nvim/lua/config/keymaps.lua)
-----------------------------------------------------------

local map = vim.keymap.set

-----------------------------------------------------------
-- General & File Operations
-----------------------------------------------------------

-- Save file
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File", silent = true })

-- Quit & Force Quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit", silent = true })
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force Quit", silent = true })

-- Save & Quit (Ubah ke <leader>z atau <leader>wq agar tidak bentrok dengan close buffer)
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save & Quit", silent = true })

-- Clear search highlight dengan Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlight" })

-----------------------------------------------------------
-- Edit & Navigasi Teks (QoL Upgrades)
-----------------------------------------------------------

-- Pindahkan baris ke atas/bawah pada Visual Mode (sangat berguna untuk refactoring code)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })

-- Tetap berada di mode Visual saat melakukan Indentasi (shift tab/indent)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Menjaga posisi kursor tetap di tengah saat scroll baris setengah layar
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Menjaga posisi kursor di tengah saat mencari kata (n / N)
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Paste tanpa menimpa isi Clipboard (register)
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard" })

-----------------------------------------------------------
-- Bufferline & Buffer Management
-----------------------------------------------------------

map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
-- Hapus buffer tanpa menutup window / quit Neovim
map("n", "<leader>bd", "<cmd>bprevious | bdelete #<CR>", { desc = "Close Buffer Safely" })

-----------------------------------------------------------
-- Window Navigation & Management
-----------------------------------------------------------

-- Pindah antar split window
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Split Window
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Horizontal Split" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
map("n", "<leader>wq", "<C-w>c", { desc = "Close Window" })

-- Resize Split Window dengan Panah
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-----------------------------------------------------------
-- Visual Mode
-----------------------------------------------------------

-- Tab untuk geser kanan di Visual Mode
map("v", "<Tab>", ">gv", { desc = "Indent Right" })

-- Shift + Tab untuk geser kiri di Visual Mode
map("v", "<S-Tab>", "<gv", { desc = "Indent Left" })


-----------------------------------------------------------
-- Terminal Mode
-----------------------------------------------------------

-- Keluar dari Terminal Mode ke Normal Mode
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })




