-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

local status, telescope = pcall(require, "telescope.builtin")
if status then
  -- Telescope
  map("n", "<leader>ff", telescope.find_files)
  map("n", "<leader>fg", telescope.live_grep)
  map("n", "<leader>fb", telescope.buffers)
  map("n", "<leader>fh", telescope.help_tags)
  map("n", "<leader>fs", telescope.git_status)
  map("n", "<leader>fc", telescope.git_commits)
else
  print("Telescope not found")
end

-- DAP
map("n", "<F9>", "<CMD>DapToggleBreakpoint<CR>")
map("v", "<F9>", "<CMD>DapToggleBreakpoint<CR>")

map("n", "<C-<F10>>", "<CMD>DapStepInto<CR>")
map("v", "<C-<F10>>", "<CMD>DapStepInto<CR>")

map("n", "<F10>", "<CMD>DapStepOver<CR>")
map("v", "<F10>", "<CMD>DapStepOver<CR>")

map("n", "<F8>", "<CMD>DapStepOut<CR>")
map("v", "<F8>", "<CMD>DapStepOut<CR>")

map("n", "<F5>", "<CMD>DapContinue<CR>")
map("v", "<F5>", "<CMD>DapContinue<CR>")

--local dapui = require("dapui")
--map("n", "<C-<F9>>", dapui.toggle())

-- Buffer
map("n", "gt", "<CMD>bnext<CR>")
map("n", "gT", "<CMD>bprevious<CR>")
map("n", "gb", "<CMD>bdelete<CR>")

-- Terminal
map("n", "<leader>th", "<CMD>ToggleTerm size=10 direction=horizontal<CR>")
map("n", "<leader>tv", "<CMD>ToggleTerm size=80 direction=vertical<CR>")

-- editor
map("n", "z;", "A;")
map("n", "z,", "A,")
map("n", "z.", "A.")
map("n", "<Tab>", ">>_")
map("v", "<Tab>", ">gv")
map("n", "<S-Tab>", "<<_")
map("v", "<S-Tab>", "<gv")
map("n", "hh", "^")
map("n", "ll", "$")
map("n", "<leader>so", "<CMD>source<CR>")
map("n", "<C-w>", "<Plug>(expand_region_expand)")
map("v", "<C-w>", "<Plug>(expand_region_expand)")
