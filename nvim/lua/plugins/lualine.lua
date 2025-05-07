return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = false,
          component_separators = "|",
          section_separators = "",
        }
      })
    end
  }
}
