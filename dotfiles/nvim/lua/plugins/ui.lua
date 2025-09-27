return {
  {
    "Tsuzat/NeoSolarized.nvim",
      priority = 1000,
      opts = {
          style = "light",
          transparent = false
      },
      lazy = false
  },
  {
    "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = {
          theme = "solarized_light",
          icons_enabled = true,
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1
            }
          }
        }
      },
      lazy = false
  },
  {
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {}
  },
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
      opts = {}
  },
  {
    "tomasky/bookmarks.nvim",
      opts = {
        sign_priority = 8,  --set bookmark sign priority to cover other sign
        save_file = vim.fn.expand "$HOME/.bookmarks", -- bookmarks save file path
        keywords =  {
          ["@r"] = "r", -- mark annotation startswith @r ,signs this icon as `Read Only`
          ["@f"] = "f", -- mark annotation startswith @f ,signs this icon as `Fix`
        },
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          vim.keymap.set("n","mm",bm.bookmark_toggle) -- add or remove bookmark at current line
          vim.keymap.set("n","mi",bm.bookmark_ann) -- add or edit mark annotation at current line
          vim.keymap.set("n","ma",bm.bookmark_list) -- show marked file list in quickfix window
          vim.keymap.set("n","mc",bm.bookmark_clean) -- clean all marks in local buffer
          vim.keymap.set("n","mx",bm.bookmark_clear_all) -- removes all bookmarks
        end
      },
      event = "BufEnter"
  },
}
