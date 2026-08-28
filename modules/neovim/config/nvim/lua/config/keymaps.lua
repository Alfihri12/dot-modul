-------------------------------------------------------
-- keymaps
-----------------------------------------------------------

local map = vim.keymap.set

-----------------------------------------------------------
-- General
-----------------------------------------------------------

-- Save file
map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save File", silent = true, })

-- Quit
map("n", "<leader>q", "<cmd>q<CR>", {desc = "Quit", silent = true, })

-- Force Quit
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force Quit", silent = true, })

-- Save & Quit
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save & Quit", silent = true, })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlight", })

-----------------------------------------------------------
-- Window Navigation
-----------------------------------------------------------

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>")

-- Pindah antar split window
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", })

-----------------------------------------------------------
-- Window Management
-----------------------------------------------------------

-- Split horizontal
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Horizontal Split", })

-- Split vertical
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vertical Split", })

-- Tutup window
map("n", "<leader>wq", "<C-w>c", { desc = "Close Window", })

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- Neo-tree open/close
map("n", "<leader>e", "<cmd>Neotree toggle<CR>")



