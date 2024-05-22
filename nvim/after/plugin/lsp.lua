local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")
local diagnostic = vim.diagnostic

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.preset("recommended")

lsp.setup()

-- lspconfig.nushell.setup()

diagnostic.config({
  virtual_text = true
})
