return {
  -- 1. Tree-sitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "nu" })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.nu = {
        install_info = {
          url = "https://github.com/nushell/tree-sitter-nu",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "nu",
      }
    end,
  },

  -- 2. Filetype detection + auto highlight enable
  {
    "nvim-lua/plenary.nvim", -- dummy plugin for config
    lazy = false,
    config = function()
      vim.filetype.add({
        extension = { nu = "nu" },
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.nu",
        callback = function()
          vim.cmd("TSBufEnable highlight")
        end,
      })
    end,
  },
}

