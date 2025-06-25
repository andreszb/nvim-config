# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Configuration Architecture

This is a Neovim configuration built with **nixCats** - a Nix-based package manager for Neovim that replaces lazy.nvim and mason. The architecture follows these principles:

- **Nix manages all plugins**: No lazy.nvim or mason when using nix - all plugins are declaratively managed in `flake.nix`
- **Category-based loading**: Plugins are organized into categories (general, debug, lint, format, etc.) and only loaded if their category is enabled
- **Lazy loading via lze**: Uses `lze` (not lazy.nvim) for lazy loading plugins based on filetypes, commands, etc.
- **Dual compatibility**: Config works both with and without nix via fallback mechanisms

### Key Files Structure

- `flake.nix`: Main nix configuration defining all plugins, LSPs, and build dependencies
- `init.lua`: Entry point that sets up nixCats compatibility and loads main config
- `lua/myLuaConf/init.lua`: Main configuration orchestrator
- `lua/myLuaConf/plugins/`: Plugin configurations organized by function
- `lua/myLuaConf/LSPs/`: LSP configurations with on_attach handlers
- `lua/nixCatsUtils/`: Utility functions for nixCats compatibility

### Plugin Loading System

The config uses a sophisticated category-based system:
1. Categories are defined in `flake.nix` under `categoryDefinitions`
2. Each package definition enables specific categories
3. Lua code checks `nixCats('category')` before loading features
4. `lze` handles lazy loading with custom handlers for categories and LSPs

### Package Definitions

Two main packages are defined:
- `nixCats`: Full-featured package with most categories enabled
- `regularCats`: Alternative package with different theme and settings

## Common Development Commands

This is a Nix flake configuration, so standard Nix commands apply:

```bash
# Build the default nixCats package
nix build

# Run nixCats directly
nix run

# Enter development shell
nix develop

# Update flake inputs
nix flake update

# Check flake
nix flake check
```

## Configuration Patterns

When modifying this config:

1. **Adding plugins**: Add to appropriate category in `flake.nix` `startupPlugins` or `optionalPlugins`
2. **Plugin configuration**: Create config in `lua/myLuaConf/plugins/` and load conditionally
3. **LSPs**: Add to `lspsAndRuntimeDeps` in flake.nix and configure in `lua/myLuaConf/LSPs/`
4. **Category checks**: Always use `nixCats('category')` to conditionally load features
5. **Lazy loading**: Use `lze` specs with `for_cat` handler for category-based loading

The config maintains compatibility with non-nix environments through the `nixCatsUtils` setup and `non_nix_download.lua` fallback system.

## Adding New Plugins - Step by Step

To add a new plugin (example: toggleterm-nvim):

### Step 1: Add plugin to flake.nix
Add the plugin to the appropriate category in `flake.nix`:

```nix
optionalPlugins = {
  general = {
    extra = with pkgs.vimPlugins; [
      toggleterm-nvim # Terminal management plugin
      # ... other plugins
    ];
  };
};
```

### Step 2: Create plugin configuration file
Create a new file in `lua/myLuaConf/plugins/` (e.g., `toggleterm.lua`):

```lua
-- Plugin configuration following nixCats pattern
return {
  {
    'toggleterm.nvim',
    for_cat = 'general.extra',     -- Category check using for_cat
    event = 'DeferredUIEnter',     -- Lazy loading trigger (not VeryLazy!)
    after = function()             -- Use 'after' not 'config' for nixCats
      require('toggleterm').setup({
        -- Plugin configuration here
      })
    end,
  },
}
```

### Step 3: Add to plugin loader
Add the import to `lua/myLuaConf/plugins/init.lua`:

```lua
require('lze').load {
  -- ... existing imports
  { import = "myLuaConf.plugins.toggleterm", },
}
```

### Step 4: Build and test
```bash
nix build  # Test the configuration builds
nix run    # Run to test the plugin loads
```

### Key Patterns:
- **for_cat**: Use instead of `if not nixCats('category')` checks
- **after**: Use instead of `config` for setup functions
- **Category matching**: Plugin name in flake.nix should match the string in `for_cat`
- **Import**: Always add the import to `plugins/init.lua` to load the configuration
```

## Plugin Modularization Patterns

### Modular Configuration Architecture

We use a modular approach for complex plugins that have multiple sub-modules (like `mini.nvim` and `snacks.nvim`). This keeps configurations organized and maintainable.

#### Snacks.nvim Modularization Pattern

For `snacks.nvim`, we break each feature into separate files and merge configurations:

```lua
-- lua/myLuaConf/plugins/misc/snacks.lua
local snacks_modules = {
  -- UI modules
  require('myLuaConf.plugins.ui.snacks-notifier'),
  require('myLuaConf.plugins.ui.snacks-dashboard'),
  require('myLuaConf.plugins.ui.snacks-statuscolumn'),
  require('myLuaConf.plugins.ui.snacks-words'),
  
  -- Editing modules
  require('myLuaConf.plugins.editing.snacks-bufdelete'),
  require('myLuaConf.plugins.editing.snacks-scratch'),
  
  -- Git modules
  require('myLuaConf.plugins.git.snacks-gitbrowse'),
  require('myLuaConf.plugins.git.snacks-lazygit'),
  
  -- Tool modules  
  require('myLuaConf.plugins.tools.snacks-rename'),
  require('myLuaConf.plugins.tools.snacks-toggle'),
  require('myLuaConf.plugins.tools.snacks-win'),
  require('myLuaConf.plugins.tools.snacks-debug'),
  
  -- Misc modules
  require('myLuaConf.plugins.misc.snacks-quickfile'),
  require('myLuaConf.plugins.misc.snacks-bigfile'),
  require('myLuaConf.plugins.misc.snacks-styles'),
}

-- Merge all modular configurations
local snacks_config = {}
for _, module in ipairs(snacks_modules) do
  for k, v in pairs(module) do
    snacks_config[k] = v
  end
end
```

Each snacks module file returns a table with its configuration:
```lua
-- lua/myLuaConf/plugins/ui/snacks-notifier.lua
return {
  notifier = { enabled = false },
}
```

#### Mini.nvim Modularization Pattern

For `mini.nvim`, we break each mini plugin into separate files with setup functions:

```lua
-- lua/myLuaConf/plugins/misc/mini.lua
local mini_modules = {
  -- Editing modules
  { module = require('myLuaConf.plugins.editing.mini-pairs'), setup = 'pairs' },
  { module = require('myLuaConf.plugins.editing.mini-ai'), setup = 'ai' },
  
  -- UI modules
  { module = require('myLuaConf.plugins.ui.mini-icons'), setup = 'icons' },
  { module = require('myLuaConf.plugins.ui.mini-animate'), setup = 'animate' },
}

-- Setup all mini modules
for _, mini_config in ipairs(mini_modules) do
  mini_config.module[mini_config.setup]()
end
```

Each mini module file returns a table with its setup function:
```lua
-- lua/myLuaConf/plugins/editing/mini-pairs.lua
return {
  pairs = function()
    require('mini.pairs').setup()
  end,
}
```

#### Benefits of This Approach

1. **Organized by functionality**: Files are categorized by their purpose (ui/, editing/, git/, tools/, misc/)
2. **Easy maintenance**: Individual features can be modified independently
3. **Clean main files**: Main plugin files are concise and use loops instead of repetitive code
4. **Consistent patterns**: Both snacks and mini follow similar modular approaches
5. **Scalable**: Easy to add new modules or remove existing ones

#### When to Use Modular Patterns

- **Large plugin suites**: For plugins like mini.nvim or snacks.nvim with many sub-features
- **Complex configurations**: When a single plugin file would become too large (>100 lines)
- **Logical groupings**: When features can be naturally categorized by functionality
- **Team maintenance**: When multiple people need to work on different aspects of the configuration

## Important Memories

- Remember we are loading plugins lazily using 'lze' and not 'lazy.nvim' package manager.
- Use modular patterns for complex plugin suites like mini.nvim and snacks.nvim
- Organize modular files by functionality: ui/, editing/, git/, tools/, misc/
- Use loops and tables instead of repetitive function calls for cleaner code