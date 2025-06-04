vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>q", function()
  if vim.bo.modified then
    vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
  else
    vim.cmd("q")
  end
end, { noremap = true, desc = "Quit if buffer is not modified" })

vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true })

vim.keymap.set('n', '<leader>sc', ':source ~/.config/nvim/init.lua<CR>',
  { noremap = true }
)

-- split screen and navigation
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { noremap = true })

vim.keymap.set("n", "<leader><leader>", "/", { noremap = true })
