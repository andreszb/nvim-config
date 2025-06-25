return {
  {
    'edgy.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',
    keys = {
      {
        '<leader>ue',
        function() require('edgy').toggle() end,
        desc = 'Toggle Edgy',
      },
      {
        '<C-e>',
        function() require('edgy').toggle('left') end,
        desc = 'Toggle Left Panel',
      },
      {
        '<leader>ur',
        function() require('edgy').toggle('right') end,
        desc = 'Toggle Right Panel',
      },
      {
        '<leader>ub',
        function() require('edgy').toggle('bottom') end,
        desc = 'Toggle Bottom Panel',
      },
    },
    after = function()
      -- views can only be fully collapsed with the global statusline
      vim.opt.laststatus = 3
      -- Default splitting will cause your main splits to jump when opening an edgebar.
      -- To prevent this, set `splitkeep` to either `screen` or `topline`.
      vim.opt.splitkeep = "screen"
      
      require('edgy').setup({
        -- Animation options
        animate = {
          enabled = true,
          fps = 200, -- Doubled from 100
          cps = 240, -- Doubled from 120
        },

        -- Exit behavior
        exit_when_last = false, -- Keep edgy windows open, show dashboard instead
        close_when_all_hidden = true,

        -- Left sidebar configuration
        left = {
          {
            title = 'File Tree',
            ft = 'neo-tree',
            filter = function(buf) return vim.b[buf].neo_tree_source == 'filesystem' end,
            size = { height = 0.5 },
            open = "Neotree reveal=true",
            pinned = true,
          },
          {
            title = 'Git',
            ft = 'neo-tree',
            filter = function(buf) return vim.b[buf].neo_tree_source == 'git_status' end,
            pinned = true,
            open = 'Neotree position=right git_status',
          },
          {
            title = 'Buffers',
            ft = 'neo-tree',
            filter = function(buf) return vim.b[buf].neo_tree_source == 'buffers' end,
            pinned = true,
            collapsed = true,
            open = 'Neotree position=top buffers',
          },
        },

        -- Right sidebar configuration
        right = {
          {
            title = 'Search and Replace',
            ft = 'grug-far',
            pinned = true,
            open = function() require('grug-far').open() end,
          },
          {
            title = 'Undotree',
            ft = 'undotree',
            pinned = true,
            open = 'UndotreeToggle',
          },
        },

        -- Bottom panel configuration
        bottom = {
          {
            title = 'Trouble',
            ft = 'trouble',
            pinned = true,
            open = function() require('trouble').toggle() end,
            filter = function(buf, win)
              return vim.w[win].trouble
                and vim.w[win].trouble.position == 'bottom'
                and vim.w[win].trouble.type == 'split'
                and vim.w[win].trouble.relative == 'editor'
                and not vim.w[win].trouble_preview
            end,
          },
          {
            title = 'QuickFix',
            ft = 'qf',
            pinned = true,
            open = 'copen',
          },
          {
            title = 'Location List',
            ft = 'qf',
            pinned = true,
            open = 'lopen',
          },
          {
            title = 'Help',
            ft = 'help',
            pinned = true,
            size = { height = 20 },
            filter = function(buf) return vim.bo[buf].buftype == 'help' end,
          },
        },

        -- Key mappings
        keys = {
          -- Increase width
          ['<c-Right>'] = function(win) win:resize('width', 2) end,
          -- Decrease width
          ['<c-Left>'] = function(win) win:resize('width', -2) end,
          -- Increase height
          ['<c-Up>'] = function(win) win:resize('height', 2) end,
          -- Decrease height
          ['<c-Down>'] = function(win) win:resize('height', -2) end,
        },

        -- Fix for some filetypes
        fix = {
          -- Fix trouble buffers
          ['trouble'] = {
            pinned = true,
            open = function() require('trouble').toggle() end,
          },
          -- Fix grug-far buffers
          ['grug-far'] = {
            pinned = true,
            open = function() require('grug-far').open() end,
          },
        },
      })
    end,
  },
}
