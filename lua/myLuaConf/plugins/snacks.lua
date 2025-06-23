-- Snacks.nvim: Collection of small, useful utilities by folke
-- Complements existing setup with lightweight conveniences
return {
  {
    'snacks.nvim',
    for_cat = 'general.extra',
    priority = 1000, -- Load early since many features are foundational

    -- Key mappings for snacks utilities
    keys = {
      -- Terminal management
      -- { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },

      -- Git integration
      -- { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git Blame Line' },
      { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse' },

      -- Buffer management
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },

      -- File operations
      { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
      { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },

      -- Notifications
      { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },

      -- Words highlighting (like VSCode)
      -- { '<leader>uw', function() Snacks.words.toggle() end, desc = 'Toggle Word Highlighting' },

      -- Window management
      -- { '<leader>wz', function() Snacks.win.zoom() end, desc = 'Zoom Window' },

      -- Quick actions
      { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
    },

    after = function()
      require('snacks').setup({
        -- Notifier disabled - using noice.nvim for notifications instead
        notifier = { enabled = false },

        -- Better handling of large files
        bigfile = {
          enabled = true,
          -- Disable features for files larger than 1.5MB
          size = 1.5 * 1024 * 1024,
          setup = function()
            vim.cmd('syntax off')
            vim.cmd('IlluminatePauseBuf') -- Disable word highlighting
            vim.opt_local.foldmethod = 'manual'
            vim.opt_local.spell = false
          end,
        },

        -- Smart buffer deletion
        bufdelete = { enabled = true },

        -- Git integration
        gitbrowse = {
          enabled = true,
          -- Open files in browser (GitHub, GitLab, etc.)
          url_patterns = {
            ['github.com'] = {
              branch = '/tree/{branch}',
              file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
              commit = '/commit/{commit}',
            },
          },
        },

        -- LazyGit integration
        lazygit = {
          enabled = true,
          -- Window configuration
          win = {
            style = 'lazygit',
            width = 0.9,
            height = 0.9,
          },
        },

        -- Fast file operations
        quickfile = { enabled = true },

        -- File/buffer renaming
        rename = { enabled = true },

        -- Scratch buffer management
        scratch = {
          enabled = true,
          name = 'scratch',
          ft = function()
            if vim.bo.buftype == '' and vim.bo.filetype == '' then
              return 'markdown'
            end
            return vim.bo.filetype
          end,
        },

        -- Enhanced status column
        statuscolumn = {
          enabled = true,
          left = { 'mark', 'sign' },
          right = { 'fold', 'git' },
          folds = {
            open = true,
            git_hl = true,
          },
          git = {
            patterns = { 'GitSign', 'MiniDiffSign' },
          },
        },

        -- -- Better terminal integration
        -- terminal = {
        --   enabled = true,
        --   win = {
        --     style = "terminal",
        --     position = "float",
        --     width = 0.8,
        --     height = 0.8,
        --   },
        -- },

        -- Option toggling utilities
        toggle = { enabled = true },

        -- Word highlighting (like VSCode's symbol highlighting)
        words = {
          enabled = true,
          debounce = 200,
          notify_jump = false,
          notify_end = true,
          foldopen = true,
          jumplist = true,
          modes = { 'n', 'i', 'c' },
        },

        -- Window management utilities
        win = { enabled = true },

        -- Debug utilities
        debug = { enabled = false }, -- Disable unless needed for development

        -- Additional styles for floating windows
        styles = {
          notification = {
            wo = { wrap = true },
            bo = { filetype = 'snacks_notif' },
          },
          terminal = {
            bo = { filetype = 'snacks_terminal' },
            wo = {},
          },
          lazygit = {
            bo = { filetype = 'snacks_lazygit' },
            wo = { colorcolumn = '' },
          },
        },
      })
    end,
  },
}

