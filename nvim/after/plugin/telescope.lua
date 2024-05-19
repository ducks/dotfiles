local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', function()
	builtin
	.current_buffer_fuzzy_find(themes
	.get_dropdown {
  		previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sw', function()
	builtin.grep_string({ search = vim.fn.input("rg > ") })
end)

vim.keymap.set('n', '<leader>sg', builtin.live_grep, { 
	desc = '[S]earch by [G]rep' 
})
