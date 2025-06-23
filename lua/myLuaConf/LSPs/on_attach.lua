return function(_, bufnr)
  -- Define diagnostic signs
  local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- Set up subtle highlight groups for virtual text with matching backgrounds
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', {
    fg = '#f38ba8',
    bg = '#2d1b20',
    blend = 20
  })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', {
    fg = '#f9e2af',
    bg = '#2d281a',
    blend = 20
  })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', {
    fg = '#89b4fa',
    bg = '#1a2332',
    blend = 20
  })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', {
    fg = '#94e2d5',
    bg = '#1e2d2a',
    blend = 20
  })

  -- Configure diagnostics with inline virtual text
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
    float = {
      source = 'always',
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = signs.Error,
        [vim.diagnostic.severity.WARN] = signs.Warn,
        [vim.diagnostic.severity.HINT] = signs.Hint,
        [vim.diagnostic.severity.INFO] = signs.Info,
      }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

  -- NOTE: why are these functions that call the telescope builtin?
  -- because otherwise they would load telescope eagerly when this is defined.
  -- due to us using the on_require handler to make sure it is available.
  if nixCats('general.telescope') then
    nmap('gr', function() require('telescope.builtin').lsp_references() end, '[G]oto [R]eferences')
    nmap('gI', function() require('telescope.builtin').lsp_implementations() end, '[G]oto [I]mplementation')
    nmap('<leader>ds', function() require('telescope.builtin').lsp_document_symbols() end, '[D]ocument [S]ymbols')
    nmap('<leader>ws', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, '[W]orkspace [S]ymbols')
  end -- TODO: someone who knows the builtin versions of these to do instead help me out please.

  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- Enable CodeLens if supported by the LSP server
  local client = vim.lsp.get_client_by_id(vim.tbl_keys(vim.lsp.get_clients({ bufnr = bufnr }))[1])
  if client and client.server_capabilities.codeLensProvider then
    -- Refresh CodeLens on buffer events
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh()
      end,
    })
    
    -- Add keymaps for CodeLens
    nmap('<leader>cl', vim.lsp.codelens.run, '[C]ode [L]ens Run')
    nmap('<leader>cr', vim.lsp.codelens.refresh, '[C]ode Lens [R]efresh')
    
    -- Initial CodeLens refresh
    vim.lsp.codelens.refresh()
  end

end
