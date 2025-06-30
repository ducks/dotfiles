-- API
--

local api = vim.api

-- remove trailing spaces when saving
api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local substitutions = {
      ["\u{201C}"] = '"',  -- left double quote
      ["\u{201D}"] = '"',  -- right double quote
      ["\u{2018}"] = "'",  -- left single quote
      ["\u{2019}"] = "'",  -- right single quote
      ["\u{2014}"] = "--", -- em dash
      ["\u{2013}"] = "-",  -- en dash
      ["\u{2026}"] = "...",-- ellipsis
      ["\u{00A0}"] = " ",  -- non-breaking space
      ["\u{2010}"] = "-",  -- hyphen (non-ASCII)
      ["\u{00AB}"] = "<<", -- left guillemet
      ["\u{00BB}"] = ">>", -- right guillemet
      ["\u{2022}"] = "*",  -- bullet
    }

    for from, to in pairs(substitutions) do
      vim.cmd(string.format("silent %%s/%s/%s/ge", from, to))
    end
  end,
})
