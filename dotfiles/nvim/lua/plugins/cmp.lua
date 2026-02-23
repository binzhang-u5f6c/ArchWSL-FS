return {
  {
    "hrsh7th/cmp-nvim-lsp",
      event = "VeryLazy",
      opts = {},
  },
  { 
    "hrsh7th/cmp-buffer",
      event = "VeryLazy",
  },
  { 
    "hrsh7th/cmp-path",
      event = "VeryLazy",
  },
  { 
    "hrsh7th/cmp-cmdline",
      event = "VeryLazy",
  },
  {
    "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          snippet = {},
          window = {
            completion = cmp.config.window.bordered({
              border = "rounded",
              winhighlight = "Normal:Normal,FloatBorder:None,CursorLine:Visual,Search:None",
            }),
            documentation = cmp.config.window.bordered({
              border = "rounded",
              winhighlight = "Normal:Normal,FloatBorder:None,CursorLine:Visual,Search:None",
            }),
          },
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            -- Accept currently selected item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          },
        })
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        })
        cmp.setup.cmdline(":" , {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "cmdline" },
            { name = "path" },
          },
          matching = { disallow_symbol_nonprefix_matching = false },
        })
      end,
  },
}
