return {
  {
    "Tsuzat/NeoSolarized.nvim",
      priority = 1000,
      lazy = false,
      opts = {
          style = "light",
          transparent = false,
      },
  },
  {
    "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      lazy = false,
      opts = {
        options = {
          theme = "solarized_light",
          icons_enabled = true,
        },
        sections = {
          lualine_c = {
            { "filename", path = 1 },
          },
        },
      },
  },
  {
    "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      config = function()
        local ts = require("nvim-treesitter.configs")
        ts.setup({
          ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "markdown",
            "markdown_inline",
            "python",
          },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnv",
              node_incremental = "gna",
              scope_incremental = "gnA",
              node_decremental = "gni",
            },
          },
          indent = { enable = false },
        })
      end,
      build = ":TSUpdate",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
      lazy = false,
      opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = false,
      init = function()
        vim.g.no_plugin_maps = true
      end,
      opts = {
        select = { lookahead = true },
      },
  },
  {
    "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      event = "VeryLazy",
      opts = {
        extensions = {
          bookmarks = {},
        },
      },
  },
  { 
    "tpope/vim-fugitive",
      event = "VeryLazy",
  },
  {
    "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      opts = {},
  },
  {
    "tomasky/bookmarks.nvim",
      event = "BufEnter",
      opts = {
        --set bookmark sign priority to cover other sign
        sign_priority = 8,
        -- bookmarks save file path
        save_file = vim.fn.stdpath("data") .. "/bookmark",
        keywords =  {
          -- mark annotation startswith @r ,signs this icon as `Read Only`
          ["@r"] = "",
          -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@t"] = "",
        },
      },
  },
}
