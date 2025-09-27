return {
  {
    "neovim/nvim-lspconfig",
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
                    ignore = {"E501", "W503", "W504"}
                },
                autopep8 = { enabled = false },
                yapf = { enabled = true },
                pydocstyle = { enabled = true },
              }
            }
          },
        })
        vim.opt.updatetime = 300
        vim.cmd [[
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })
        ]]
      end
  },
}
