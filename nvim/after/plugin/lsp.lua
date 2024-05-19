local lsp = require("lsp-zero")
local diagnostic = vim.diagnostic

lsp.preset("recommended")

lsp.setup()

diagnostic.config({
  virtual_text = true
})
