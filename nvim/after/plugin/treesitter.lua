require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  ensure_installed = {
    "c",
    "javascript",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "typescript",
    "rust",
    "nu"
  }
}
