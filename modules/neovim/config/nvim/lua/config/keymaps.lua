-------------------------------------------------------
-- keymaps
-----------------------------------------------------------

local map = vim.keymap.set

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-----------------------------------------------------------
-- General
-----------------------------------------------------------

-- Save file
map("n", "<leader>s", "<cmd>w<CR>", {
    desc = "Save File",
    silent = true,
})

-- Quit
map("n", "<leader>q", "<cmd>q<CR>", {
    desc = "Quit",
    silent = true,
})

-- Force Quit
map("n", "<leader>Q", "<cmd>q!<CR>", {
    desc = "Force Quit",
    silent = true,
})

-- Save & Quit
map("n", "<leader>x", "<cmd>wq<CR>", {
    desc = "Save & Quit",
    silent = true,
})

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
    desc = "Clear Search Highlight",
})

-----------------------------------------------------------
-- Clipboard
-----------------------------------------------------------

-- Copy ke clipboard system
map({ "n", "v" }, "<leader>y", '"+y', {
    desc = "Copy to System Clipboard",
})

-- Paste dari clipboard system
map("n", "<leader>p", '"+p', {
    desc = "Paste from System Clipboard",
})

map("v", "<leader>p", '"+p', {
    desc = "Paste from System Clipboard",
})

-----------------------------------------------------------
-- Window Navigation
-----------------------------------------------------------

-- Pindah antar split window
map("n", "<C-h>", "<C-w>h", {
    desc = "Go to Left Window",
})

map("n", "<C-j>", "<C-w>j", {
    desc = "Go to Lower Window",
})

map("n", "<C-k>", "<C-w>k", {
    desc = "Go to Upper Window",
})

map("n", "<C-l>", "<C-w>l", {
    desc = "Go to Right Window",
})

-----------------------------------------------------------
-- Window Management
-----------------------------------------------------------

-- Split horizontal
map("n", "<leader>wh", "<cmd>split<CR>", {
    desc = "Horizontal Split",
})

-- Split vertical
map("n", "<leader>wv", "<cmd>vsplit<CR>", {
    desc = "Vertical Split",
})

-- Tutup window
map("n", "<leader>wq", "<C-w>c", {
    desc = "Close Window",
})

-----------------------------------------------------------
-- Resize Window
-----------------------------------------------------------

map("n", "<C-Up>", "<cmd>resize +2<CR>", {
    desc = "Increase Window Height",
})

map("n", "<C-Down>", "<cmd>resize -2<CR>", {
    desc = "Decrease Window Height",
})

map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", {
    desc = "Decrease Window Width",
})

map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", {
    desc = "Increase Window Width",
})

-----------------------------------------------------------
-- Buffer
-----------------------------------------------------------

-- Buffer berikutnya
map("n", "<leader>bn", "<cmd>bnext<CR>", {
    desc = "Next Buffer",
})

-- Buffer sebelumnya
map("n", "<leader>bp", "<cmd>bprevious<CR>", {
    desc = "Previous Buffer",
})

-- Tutup buffer sekarang
map("n", "<leader>bd", "<cmd>bdelete<CR>", {
    desc = "Delete Buffer",
})

-----------------------------------------------------------
-- Better Indent
-----------------------------------------------------------

-- Tetap stay di visual mode setelah indent
map("v", "<", "<gv", {
    desc = "Indent Left",
})

map("v", ">", ">gv", {
    desc = "Indent Right",
})



