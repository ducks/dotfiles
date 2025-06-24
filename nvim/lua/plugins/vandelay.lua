return {
  'ducks/nvim-vandelay',
  config = function()
    vim.keymap.set('n', '<leader>mi', function()
      require('vandelay').format_current_line()
    end, { noremap = true, silent = true })
  end
}
