return {
  {
    'grug-far.nvim',
    for_cat = 'general.extra',
    keys = {
      {
        '<leader>sr',
        function()
          require('grug-far').open()
        end,
        desc = 'Search and Replace',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
        end,
        desc = 'Search and Replace (word under cursor)',
      },
      {
        '<leader>sF',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
        end,
        desc = 'Search and Replace (current file)',
      },
      {
        '<leader>sr',
        function()
          require('grug-far').with_visual_selection()
        end,
        mode = 'v',
        desc = 'Search and Replace (visual selection)',
      },
    },
    after = function()
      require('grug-far').setup {
        -- Options for the search and replace interface
        windowCreationCommand = 'vsplit', -- Open in vertical split (edgy will manage positioning)
        
        -- Keymaps within grug-far buffer
        keymaps = {
          replace = { n = '<leader>r' },
          qflist = { n = '<leader>q' },
          syncLocations = { n = '<leader>s' },
          syncLine = { n = '<leader>l' },
          close = { n = '<leader>c' },
          historyOpen = { n = '<leader>t' },
          historyAdd = { n = '<leader>a' },
          refresh = { n = '<leader>f' },
          openLocation = { n = '<leader>o' },
          gotoLocation = { n = '<enter>' },
          pickHistoryEntry = { n = '<enter>' },
          abort = { n = '<leader>b' },
          help = { n = 'g?' },
        },
        
        -- Disable some keymaps if needed
        disableBufferLineNumbers = false,
        maxWorkers = 4,
        
        -- Search tool priority
        engines = {
          ripgrep = {
            path = 'rg',
            extraArgs = '',
            placeholders = {
              enabled = true,
              search = 'ex: foo    foo.*    (?i)foo',
              replacement = 'ex: bar    $&    ${1}_foo',
              filesFilter = 'ex: *.lua    *.{css,js}    **/docs/*.md',
              flags = 'ex: --help --ignore-case (-i) --replace= (empty replace) --multiline (-U)',
              paths = 'ex: /foo/bar    ../    ./hello.lua    ./src/foo.lua',
            },
          },
        },
        
        -- Icons
        icons = {
          enabled = true,
          searchInput = ' ',
          replaceInput = ' ',
          filesFilterInput = ' ',
          flagsInput = ' ',
          pathsInput = ' ',
        },
        
        -- Spinner
        spinnerStates = {
          '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'
        },
        
        -- Folding
        folding = {
          enabled = true,
          folds = {
            {
              label = ' Search and Replace',
              type = 'header',
            },
            {
              label = ' Files Filter',
              type = 'filesFilter',
            },
            {
              label = ' Flags',
              type = 'flags', 
            },
            {
              label = ' Paths',
              type = 'paths',
            },
          },
        },
        
        -- Results
        resultsSeparatorLineChar = '─',
        
        -- History
        history = {
          maxSize = 10,
          autoSave = {
            enabled = true,
            onBufEnter = true,
            onFocusLost = true,
          },
        },
      }
    end,
  },
}