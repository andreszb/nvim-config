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