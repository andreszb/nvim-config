-- Neo-tree: Modern file explorer for Neovim
-- Replaces nvim-tree with better UI, multiple sources, and advanced features
return {
  {
    'neo-tree.nvim',
    for_cat = 'general.file_navigation', -- nixCats category for file navigation
    cmd = 'Neotree', -- Load when :Neotree command is used

    after = function()
      require('neo-tree').setup({
        -- Available sources: filesystem, buffers, git_status, document_symbols
        sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },

        -- Window management behavior
        close_if_last_window = false, -- Don't close neo-tree if it's the last window
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = false,

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
          -- Position and width now managed by edgy.nvim
          mapping_options = {
            noremap = true, -- Don't use recursive mappings
            nowait = true, -- Don't wait for timeout on mappings
          },

          -- Custom key mappings within neo-tree window
          mappings = {
            ['<space>'] = 'none', -- Disable space (avoid conflicts)

            -- File opening behavior
            ['<cr>'] = 'open', -- Enter opens file in current window (not split)
            ['<2-LeftMouse>'] = 'open', -- Double-click opens in current window

            -- Split opening (explicit)
            ['s'] = 'open_split', -- 's' for horizontal split
            ['v'] = 'open_vsplit', -- 'v' for vertical split
            ['t'] = 'open_tabnew', -- 't' for new tab

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
      })
    end,
  },
}
