-- PLUGINS MANAGER
-- set mapleader before lazy loader
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "
require("config.lazy")

-- EDIT
-- file format
vim.opt.fileformats = { "unix", "dos", "mac" }
-- indents and tabs
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- long lines
vim.opt.wrap = false
vim.opt.sidescroll = 20
-- search
vim.opt.ignorecase = true
vim.opt.wrapscan = false
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 99

-- UI
-- color
vim.opt.termguicolors = true
vim.opt.background = "light"
vim.cmd [[ colorscheme NeoSolarized ]]
-- view
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.signcolumn = "yes"
-- tab visible
vim.opt.list = true
vim.opt.listchars = { tab = "\\u21E4-\\u21E5" }
-- multiple windows
vim.opt.splitright = true
vim.opt.splitbelow = true
-- clipboard
local clipboard = {
  name = "WSLClipboard",
  copy = {},
  paste = {},
  cache_enabled = 0,
}
clipboard.copy["+"] = "clip.exe"
clipboard.copy["*"] = "clip.exe"
clipboard.paste["+"] = "powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))"
clipboard.paste["*"] = "powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))"
vim.g.clipboard = clipboard

-- KEY BINDING
-- quick move
vim.keymap.set("n", "<Leader>s", "<cmd>call EasyMotion#OverwinF(2)<CR>")
local builtin = require("telescope.builtin")
-- goto
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope goto def" })
vim.keymap.set("n", "gy", builtin.lsp_type_definitions, { desc = "Telescope goto typedef" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope goto ref" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Telescope goto impl" })
-- find
vim.keymap.set("n", "<Leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<Leader>b", builtin.buffers, { desc = "Telescope find buffers" })
vim.keymap.set("n", "<Leader>p", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<Leader>d", builtin.diagnostics, { desc = "Telescope show diagnostics" })
vim.keymap.set("n", "<Leader>t", builtin.lsp_document_symbols, { desc = "Telescope show symbols" })
