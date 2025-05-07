-- Options
--

local opt = vim.opt

opt.background = "dark"
opt.number = true

opt.colorcolumn = "80"

opt.updatetime = 50

opt.hlsearch = false
opt.ignorecase = true

opt.swapfile = false

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Overriding gruvbox's default ColorColumn
local gbr = vim.api.nvim_get_hl(0, { name = 'GruvboxRed' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = gbr.fg })
