return function(_, bufnr)
  -- Call the general LSP on_attach function first
  require('myLuaConf.LSPs.on_attach')(_, bufnr)

  -- Helper function for Python-specific keymaps
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Python-specific buffer options
  local opt = vim.opt_local
  opt.tabstop = 4
  opt.shiftwidth = 4
  opt.softtabstop = 4
  opt.expandtab = true
  opt.textwidth = 88  -- Black's line length
  opt.colorcolumn = "89"
  opt.foldmethod = "indent"
  opt.foldlevel = 99
  opt.commentstring = "# %s"
  
  -- Python-specific keymaps
  nmap('<leader>nr', ':!python %<CR>', 'Run Python file')
  nmap('<leader>ni', ':!python -i %<CR>', 'Run Python file interactively')
  nmap('<leader>ns', function()
    if vim.fn.executable("isort") == 1 then
      vim.cmd("!isort %")
      vim.cmd("edit!")
    else
      print("isort not found")
    end
  end, 'Sort imports with isort')
  nmap('<leader>nt', ':!pytest<CR>', 'Run pytest')
  nmap('<leader>nT', ':!pytest %<CR>', 'Run pytest on current file')

end