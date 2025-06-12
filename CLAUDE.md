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