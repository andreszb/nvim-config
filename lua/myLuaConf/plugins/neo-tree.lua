-- Neo-tree: Modern file explorer for Neovim
-- Replaces nvim-tree with better UI, multiple sources, and advanced features
return {
  {
    'neo-tree.nvim',
    for_cat = 'general.file_navigation', -- nixCats category for file navigation
    cmd = 'Neotree', -- Load when :Neotree command is used

    -- Key mappings for different neo-tree modes
    keys = {
      -- File explorer mappings
      {
        '<leader>fe',
        function() require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() }) end,
        desc = 'Explorer NeoTree (cwd)',
      },
      {
        '<leader>fE',
        function() require('neo-tree.command').execute({ toggle = true, dir = vim.fn.expand('%:p:h') }) end,
        desc = 'Explorer NeoTree (current file)',
      },
      { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (cwd)', remap = true }, -- Shortcut for above
      { '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (current file)', remap = true }, -- Shortcut for above
      {
        '<C-n>',
        function() require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() }) end,
        desc = 'Toggle Neo-tree',
      },

      -- Special source mappings
      {
        '<leader>ge',
        function() require('neo-tree.command').execute({ source = 'git_status', toggle = true }) end,
        desc = 'Git Explorer',
      },
      {
        '<leader>be',
        function() require('neo-tree.command').execute({ source = 'buffers', toggle = true }) end,
        desc = 'Buffer Explorer',
      },
    },

    -- Function called when plugin is deactivated
    deactivate = function() vim.cmd([[Neotree close]]) end,

    -- Initialization function (runs before plugin loads)
    init = function()
      -- Note: Oil plugin already disables netrw and handles directory opening
      -- Neo-tree is used for manual file exploration via key mappings
    end,
    -- Main configuration function (runs after plugin loads)
    after = function()
      require('neo-tree').setup({
        -- Available sources: filesystem, buffers, git_status, document_symbols
        sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },

        -- Don't replace these window types when opening files
        open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },

        -- Filesystem source configuration
        filesystem = {
          bind_to_cwd = false, -- Don't change neo-tree root when changing vim's cwd
          follow_current_file = { enabled = true }, -- Highlight currently open file
          use_libuv_file_watcher = true, -- Watch for file changes automatically

          -- File filtering options
          filtered_items = {
            hide_dotfiles = false, -- Show .files (like .gitignore)
            hide_gitignored = false, -- Show files ignored by git
            hide_hidden = true, -- Hide hidden files (OS-level)

            -- Hide specific directories/files by name
            hide_by_name = {
              'node_modules', -- Hide npm dependencies folder
            },

            -- Never show these files (even when showing hidden)
            never_show = {
              '.DS_Store', -- macOS metadata
              'thumbs.db', -- Windows thumbnails
            },
          },
        },
        -- Window appearance and behavior
        window = {
          position = 'left', -- Position: left, right, top, bottom, float
          width = 30, -- Width in characters

          mapping_options = {
            noremap = true, -- Don't use recursive mappings
            nowait = true, -- Don't wait for timeout on mappings
          },

          -- Custom key mappings within neo-tree window
          mappings = {
            ['<space>'] = 'none', -- Disable space (avoid conflicts)

            -- Git navigation
            ['[g'] = 'prev_git_modified', -- Go to previous git change
            [']g'] = 'next_git_modified', -- Go to next git change

            -- Sorting options (press 'o' then another key)
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false }, -- Sort by creation date
            ['od'] = { 'order_by_diagnostics', nowait = false }, -- Sort by diagnostic count
            ['om'] = { 'order_by_modified', nowait = false }, -- Sort by modification date
            ['on'] = { 'order_by_name', nowait = false }, -- Sort by name (default)
            ['os'] = { 'order_by_size', nowait = false }, -- Sort by file size
            ['ot'] = { 'order_by_type', nowait = false }, -- Sort by file type
          },
        },
        -- Default visual components configuration
        default_component_configs = {
          -- Indentation and folder expand/collapse
          indent = {
            with_expanders = true, -- Show expand/collapse arrows
            expander_collapsed = '', -- Icon for collapsed folder
            expander_expanded = '', -- Icon for expanded folder
            expander_highlight = 'NeoTreeExpander', -- Highlight group for arrows
          },

          -- Git status symbols
          git_status = {
            symbols = {
              unstaged = '󰄱', -- Icon for unstaged changes
              staged = '󰱒', -- Icon for staged changes
            },
          },
        },
        -- Custom commands (functions you can call from neo-tree)
        commands = {
          -- Open file/directory with system default application (macOS: 'open' command)
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.jobstart({ 'open', path }, { detach = true })
          end,

          -- Smart navigation: if folder is expanded, collapse it; if collapsed, go to parent
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if node:has_children() and node:is_expanded() then
              state.commands.toggle_node(state) -- Collapse if expanded
            else
              require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id()) -- Go to parent
            end
          end,

          -- Smart navigation: if folder is collapsed, expand it; if expanded, enter first child
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node:has_children() then
              if not node:is_expanded() then
                state.commands.toggle_node(state) -- Expand if collapsed
              else
                if node.type == 'file' then
                  state.commands.open(state) -- Open file
                else
                  require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1]) -- Focus first child
                end
              end
            else
              state.commands.open(state) -- Open file if it's not a directory
            end
          end,
        },
      })
    end,
  },
}
