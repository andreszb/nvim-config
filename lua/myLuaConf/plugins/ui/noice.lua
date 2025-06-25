-- Noice.nvim: Modern UI for messages, cmdline and popupmenu
-- Replaces default Neovim UI elements with a modern, customizable interface
return {
  {
    'noice.nvim',
    for_cat = 'general.extra',
    event = 'DeferredUIEnter',

    -- Key mappings for noice functionality
    keys = {

      { '<leader>sn', function() require('noice').cmd('history') end, desc = 'Noice History' },
      { '<leader>sl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
      { '<leader>sa', function() require('noice').cmd('all') end, desc = 'Noice All Messages' },
      { '<leader>st', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },

      -- Dismiss notifications
      { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },

      -- Enable/disable noice
      { '<leader>sne', function() require('noice').cmd('enable') end, desc = 'Enable Noice' },
      { '<leader>snx', function() require('noice').cmd('disable') end, desc = 'Disable Noice' },

      -- Scroll in hover documentation / signature help
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Backward',
        mode = { 'i', 'n', 's' },
      },
      
    },

    after = function()
      require('noice').setup({
        -- Command line configuration
        cmdline = {
          enabled = true,
          view = 'cmdline_popup', -- Modern popup instead of bottom line
          format = {
            -- Different command types with icons
            cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=' }, icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
            input = { view = 'cmdline_input', icon = '󰥻 ' },
          },
        },

        -- Message configuration
        messages = {
          enabled = true, -- Enable message handling
          view = 'notify', -- Use notifications for messages
          view_error = 'notify', -- Use notifications for errors
          view_warn = 'notify', -- Use notifications for warnings
          view_history = 'messages', -- Use messages view for history
          view_search = 'virtualtext', -- Use virtual text for search messages
        },

        -- Popup menu configuration (completion, etc.)
        popupmenu = {
          enabled = true,
          backend = 'nui', -- Use nui backend for modern look
          -- Fallback to default if no items available
          kind_icons = {}, -- Use default icons from your icon theme
        },

        -- Redirect and filter configuration
        redirect = {
          view = 'popup',
          filter = { event = 'msg_show' },
        },

        -- Command definitions
        commands = {
          history = {
            view = 'split',
            opts = { enter = true, format = 'details' },
            filter = {
              any = {
                { event = 'notify' },
                { error = true },
                { warning = true },
                { event = 'msg_show', kind = { '' } },
                { event = 'lsp', kind = 'message' },
              },
            },
          },
          last = {
            view = 'popup',
            opts = { enter = true, format = 'details' },
            filter = {
              any = {
                { event = 'notify' },
                { error = true },
                { warning = true },
                { event = 'msg_show', kind = { '' } },
                { event = 'lsp', kind = 'message' },
              },
            },
            filter_opts = { count = 1 },
          },
          errors = {
            view = 'popup',
            opts = { enter = true, format = 'details' },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },

        -- Notification configuration
        notify = {
          enabled = true,
          view = 'notify',
        },

        -- LSP configuration
        lsp = {
          progress = {
            enabled = true,
            format = 'lsp_progress',
            format_done = 'lsp_progress_done',
            throttle = 1000 / 30, -- Frequency of progress updates
            view = 'mini',
          },
          override = {
            -- Override LSP markdown rendering with noice
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
          hover = {
            enabled = true,
            silent = false, -- Set to true to not show message when hover is not available
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing
              luasnip = true, -- Show signature help when jumping to luasnip placeholders
              throttle = 50, -- Debounce lsp signature help request
            },
            view = nil, -- Use default floating window
            opts = {}, -- Merged with defaults from documentation
          },
          message = {
            enabled = true,
            view = 'notify',
            opts = {},
          },
          documentation = {
            view = 'hover',
            opts = {
              lang = 'markdown',
              replace = true,
              render = 'plain',
              format = { '{message}' },
              win_options = { concealcursor = 'n', conceallevel = 3 },
            },
          },
        },

        -- Markdown rendering
        markdown = {
          hover = {
            ['|(%S-)|'] = vim.cmd.help, -- vim help links
            ['%[.-%]%((%S-)%)'] = require('noice.util').open, -- markdown links
          },
          highlights = {
            ['|%S-|'] = '@text.reference',
            ['@%S+'] = '@parameter',
            ['^%s*(Parameters:)'] = '@text.title',
            ['^%s*(Return:)'] = '@text.title',
            ['^%s*(See also:)'] = '@text.title',
            ['{%S-}'] = '@parameter',
          },
        },

        -- Health check configuration
        health = {
          checker = false, -- Disable startup healthcheck
        },

        -- Smart move configuration
        smart_move = {
          enabled = true, -- Automatically move out of the way of cursor
          excluded_filetypes = { 'cmp_menu', 'cmp_docs', 'notify' },
        },

        -- Presets for common configurations
        presets = {
          bottom_search = true, -- Use classic bottom search
          command_palette = true, -- Position command palette above cmdline
          long_message_to_split = true, -- Long messages will be sent to split
          inc_rename = false, -- Enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- Add border to hover docs and signature help
        },

        -- Throttle configuration
        throttle = 1000 / 30, -- How frequently noice updates

        -- Views configuration
        views = {
          cmdline_popup = {
            position = {
              row = '50%',  -- Center vertically
              col = '50%',  -- Center horizontally
            },
            size = {
              width = 'auto',
              height = 'auto',
            },
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
            },
          },
          popupmenu = {
            relative = 'editor',
            position = {
              row = 8,
              col = '50%',
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = 'rounded',
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
            },
          },
        },

        -- Route configuration for message filtering
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
              },
            },
            view = 'mini',
          },
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'written',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'msg_show',
              find = 'search hit BOTTOM',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'msg_show',
              find = 'search hit TOP',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'emsg',
              find = 'E23',
            },
            opts = { skip = true },
          },
        },
      })
    end,
  },
}

