-- API
--

local api = vim.api

-- remove trailing spaces when saving
api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
