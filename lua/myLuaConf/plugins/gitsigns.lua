return {
  {
    'gitsigns.nvim',
    for_cat = 'general.always',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 300,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = function(name, blame_info, opts)
          if blame_info.author == 'Not Committed Yet' then
            return { { ' ' .. blame_info.author, 'GitSignsCurrentLineBlame' } }
          end

          -- Get current git user name
          local git_user = vim.fn.system('git config user.name'):gsub('\n', '')

          local current_year = os.date('%Y')
          local commit_year = os.date('%Y', blame_info.author_time)

          local date_format
          if commit_year == current_year then
            date_format = '%d %b' -- Day and three-letter month for current year
          else
            date_format = '%d %b %Y' -- Day, month, and year for other years
          end

          local date = os.date(date_format, blame_info.author_time)

          -- Format text based on whether it's the current user
          local text
          if blame_info.author == git_user then
            text = string.format(' %s - %s', date, blame_info.summary)
          else
            text = string.format(' %s, %s - %s', blame_info.author, date, blame_info.summary)
          end

          return { { text, 'GitSignsCurrentLineBlame' } }
        end,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to next hunk' })

          map({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to previous hunk' })

          -- Actions
          -- visual mode
          map(
            'v',
            '<leader>hs',
            function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'stage git hunk' }
          )
          map(
            'v',
            '<leader>hr',
            function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'reset git hunk' }
          )
          -- normal mode
          map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
          map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
          map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
          map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
          map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
          map('n', '<leader>gb', function() gs.blame_line({ full = false }) end, { desc = 'git blame line' })
          map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
          map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'git diff against last commit' })

          -- Toggles
          map('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
          map('n', '<leader>gtd', gs.toggle_deleted, { desc = 'toggle git show deleted' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
        end,
      })
      vim.cmd([[hi GitSignsAdd guifg=#04de21]])
      vim.cmd([[hi GitSignsChange guifg=#83fce6]])
      vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
    end,
  },
}

