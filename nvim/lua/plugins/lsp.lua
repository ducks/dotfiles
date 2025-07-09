return {
  -- 1. mason.nvim (core installer)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- 2. mason-lspconfig.nvim (bridge)
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "vue_ls",
        "ts_ls",
        "lua_ls",
        "rust_analyzer",
        -- add more here later
      },
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,

        -- custom volar config
        ["vue_ls"] = function()
          local tsdk = vim.fn.stdpath("data")
          .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"

          -- Optional sanity check
          if vim.fn.isdirectory(tsdk) == 0 then
            vim.notify("⚠️ Volar tsdk path missing: " .. tsdk, vim.log.levels.ERROR)
          end

          lspconfig.volar.setup({
            filetypes = {
              "vue",
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
            },
            init_options = {
              typescript = {
                tsdk = tsdk,
              },
            },
          })
        end,

        ["rust_analyzer"] = function()
          lspconfig.rust_analyzer.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
              },
            },
          })
        end,
        ["nu_ls"] = function()
          require("lspconfig").nu_ls.setup({
            cmd = { "nu", "--lsp" },
            filetypes = { "nu" },
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end
      },
    },
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },

  -- 3. nvim-lspconfig (LSP handlers)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
}
