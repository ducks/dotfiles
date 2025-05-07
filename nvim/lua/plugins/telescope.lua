local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- lazy-load when :Telescope is called
    keys = {
      {
        "<leader>p",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files"
      },
      {
        '<leader>f',
        function()
          builtin
          .current_buffer_fuzzy_find(
            themes.get_dropdown { previewer = false, }
          )
        end,
        { desc = '[/] Fuzzily search in current buffer' }
      },
    },
    opts = {
      defaults = {
        layout_config = {
          horizontal = {
            width = 0.9
          },
        },
      },
    },
  }
}
