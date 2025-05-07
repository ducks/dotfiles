return {
  { 
    'nvim-treesitter/nvim-treesitter',

    opts = {
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
      },
    },
  },
}
