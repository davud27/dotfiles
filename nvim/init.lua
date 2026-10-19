print("advent of neovim")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- Highlight when yanking (copying) text
-- Try with 'yap' in normal mode
-- See ':help vim.hl.on_yank()'
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
local pum = function() return vim.fn.pumvisible() == 1 end

vim.keymap.set("i", "<Tab>", function() return pum() and "<C-n>" or "<Tab>" end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function() return pum() and "<C-p>" or "<S-Tab>" end, { expr = true })
vim.keymap.set("i", "<CR>", function()
  return (pum() and vim.fn.complete_info({ "selected" }).selected ~= -1) and "<C-y>" or "<CR>"
end, { expr = true })

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")
  local ft = vim.bo.filetype
  if ft == "python" then
    vim.cmd("!python %")
  elseif ft == "cpp" then
    vim.cmd("!g++ -std=c++20 -Wall % -o %< && ./%<")
  elseif ft == "c" then
    vim.cmd("!gcc -Wall % -o %< && ./%<")
  elseif ft == "asm" then
    vim.cmd("!nasm -f elf64 % -o %<.o && ld %<.o -o %< && ./%<")
  end
end, { desc = "Run current file" })
