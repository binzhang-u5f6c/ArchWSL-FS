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
-- fold
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
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

-- KEY BINDING
-- quick move
vim.keymap.set("n", "gf", function()
  require("hop").hint_char2({ multi_windows = true })
end)
-- treesitter text objects
local ts_text_objects_selector = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "am", function()
  ts_text_objects_selector.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
  ts_text_objects_selector.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  ts_text_objects_selector.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  ts_text_objects_selector.select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
  ts_text_objects_selector.select_textobject("@local.scope", "locals")
end)
vim.keymap.set({ "x", "o" }, "is", function()
  ts_text_objects_selector.select_textobject("@parameter.inner", "textobjects")
end)
-- goto
local builtin = require("telescope.builtin")
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope goto def" })
vim.keymap.set("n", "gD", builtin.lsp_type_definitions, { desc = "Telescope goto typedef" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope goto ref" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Telescope goto impl" })
-- find
vim.keymap.set("n", "<Leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<Leader>b", builtin.buffers, { desc = "Telescope find buffers" })
vim.keymap.set("n", "<Leader>p", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<Leader>d", builtin.diagnostics, { desc = "Telescope show diagnostics" })
vim.keymap.set("n", "<Leader>t", builtin.lsp_document_symbols, { desc = "Telescope show symbols" })
-- bookmarks
local bm = require("bookmarks")
vim.keymap.set("n", "mm", bm.bookmark_toggle, { desc = "Bookmark add or remove bookmark at current line" })
vim.keymap.set("n", "mi", bm.bookmark_ann, { desc = "Bookmark add or edit mark annotation at current line" })
vim.keymap.set("n", "ma", require("telescope").extensions.bookmarks.list, { desc = "Bookmark show marked file list in quickfix window" })
vim.keymap.set("n", "mc", bm.bookmark_clean, { desc = "Bookmark clean all marks in local buffer" })
vim.keymap.set("n", "mx", bm.bookmark_clear_all, { desc = "Bookmark removes all bookmarks" })

-- LSP
-- basic
vim.opt.updatetime = 300
vim.cmd [[
  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })
]]
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- python
vim.lsp.config("pylsp", {
  cmd = { "pylsp", "-v", "--log-file", "/tmp/lsp_pylsp.log" },
  filetypes = { "python" },
  trace = { server = "verbose" },
  capabilities = capabilities,
  settings = {
    pylsp = {
      configurationSource = { "flake8" },
      plugins = {
        jedi = { environment = ".venv" },
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        flake8 = {
            enabled = true,
            ignore = {"E501", "W503", "W504"},
        },
        autopep8 = { enabled = false },
        yapf = { enabled = true },
        pydocstyle = { enabled = true },
      },
    },
  },
})
vim.lsp.enable("pylsp")
