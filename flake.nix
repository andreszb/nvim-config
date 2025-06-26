# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# Welcome to the main example config of nixCats!
# there is a minimal flake the starter templates use
# within the nix directory without the nixpkgs input,
# but this one would work too!
# Every config based on nixCats is a full nixCats.
# This example config doesnt use lazy.nvim, and
# it loads everything via nix.
# It has some useful tricks
# in it, especially for lsps, so if you have any questions,
# first look through the docs, and then here!
# It has examples of most of the things you would want to do
# in your main nvim configuration.
# If there is still not adequate info, ask in discussions
# on the nixCats repo (or open a PR to add the info to the help!)
{
  description = "Neovim configuration of Andres Zambrano";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # No longer fetched to avoid forcing people to import it, but this remains here as a tutorial.
    # How to import it into your config is shown farther down in the startupPlugins set.
    # You put it here like this, and then below you would use it with `pkgs.neovimPlugins.hlargs`

    # "plugins-hlargs" = {
    #   url = "github:m-demare/hlargs.nvim";
    #   flake = false;
    # };

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };
  };

  # see :help nixCats.flake.outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    # this is flake-utils eachSystem
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    # management of the system variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.
    # It gets resolved within the builder itself, and then passed to your
    # categoryDefinitions and packageDefinitions.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.

    # see :help nixCats.flake.outputs.overlays
    dependencyOverlays =
      /*
      (import ./overlays inputs) ++
      */
      [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    } @ packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        # some categories of stuff.
        general = with pkgs; [
          universal-ctags
          git
        ];
        debug = with pkgs; {
          c = [gdb];
        };
        c = with pkgs; [
          clang-tools
          lldb
          gcc
          cmake
          gnumake
        ];
        latex = with pkgs; [
          texlab
        ];
        lua = with pkgs; [
          lua-language-server # A language server for Nix
          stylua # An opinionated code formatter for Lua
        ];
        nix = with pkgs; [
          nixd # A language server for Nix
          alejandra # A formatter for Nix code.
          nix-doc
        ];
        python = with pkgs; [
          pyright # Python language server
          black # Python code formatter
          ruff # Fast Python linter
          isort # Python import sorter
        ];
        json = with pkgs; [
          vscode-langservers-extracted # JSON language server (jsonls)
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        debug = with pkgs.vimPlugins; [
          nvim-nio
        ];
        general = with pkgs.vimPlugins; {
          # you can make subcategories!!!
          # (always isnt a special name, just the one I chose for this subcategory)
          always = [
            lze # Lazy loading manager for Neovim
            lzextras # Extra utilities for lazy loading
            vim-repeat # Enables repeating plugin maps with ".".
            plenary-nvim # Lua functions used by other plugins.
            tokyonight-nvim # A dark theme for Neovim
            nui-nvim # UI component library for neo-tree
            nvzone-volt # Dependency for nvzone-menu
            nvzone-menu # Beautiful floating menu component for Neovim
            nvim-notify # Beautiful notification system for Neovim
          ];
          extra = [
            oil-nvim # A file explorer for Neovim
            oil-git-status-nvim # Git status integration for oil.nvim
            nvim-web-devicons #
            yazi-nvim # Terminal file manager integration for Neovim
            hardtime-nvim # Plugin to help break bad Vim habits
            grug-far-nvim # Find and replace across files with modern UI
            edgy-nvim # Manage window layouts and sidebar panels
            multicursor-nvim # Multiple cursors support for Neovim
          ];
        };
        themer = with pkgs.vimPlugins; (
          builtins.getAttr (categories.colorscheme or "onedark") {
            # Theme switcher without creating a new category
            "onedark" = onedark-nvim;
            "catppuccin" = catppuccin-nvim;
            "catppuccin-mocha" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
            "tokyonight-day" = tokyonight-nvim;
          }
        );
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # or a tool for organizing this like lze or lz.n!
      # to get the name packadd expects, use the
      # `:NixCats pawsible` command to see them all
      optionalPlugins = {
        debug = with pkgs.vimPlugins; {
          # it is possible to add default values.
          # there is nothing special about the word "default"
          # but we have turned this subcategory into a default value
          # via the extraCats section at the bottom of categoryDefinitions.
          default = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];
          c = [nvim-dap-lldb];
          python = with pkgs; [
            python3Packages.debugpy # Python debugger
          ];
        };
        lint = with pkgs.vimPlugins; [
          nvim-lint # Asynchronous linting engine for Neovim
        ];
        format = with pkgs.vimPlugins; [
          conform-nvim # A formatter for Neovim
        ];
        markdown = with pkgs.vimPlugins; [
          markdown-preview-nvim # Preview markdown files in a browser
        ];
        lua = with pkgs.vimPlugins; [
          lazydev-nvim # Development tools for lazy loading.
        ];
        general = {
          blink = with pkgs.vimPlugins; [
            luasnip # Snipper engine for Neovim
            cmp-cmdline # Command line completion for Neovim
            blink-cmp # Completion plugin for Neovim
            blink-compat # Compatibility layer for blink-cmp
            colorful-menu-nvim # A colorful menu for Neovim
          ];
          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter-context
            # This is for if you only want some of the grammars
            (nvim-treesitter.withPlugins (
              plugins:
                with plugins; [
                  nix
                  lua
                  c
                  markdown
                  vim
                  vimdoc
                  python
                  json
                ]
            ))
          ];
          file_navigation = with pkgs.vimPlugins; [
            neo-tree-nvim # File explorer for Neovim
          ];
          telescope = with pkgs.vimPlugins; [
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            telescope-nvim
          ];
          always = with pkgs.vimPlugins; [
            nvim-lspconfig # Quickstart configurations for LSP.
            lualine-nvim # LSP progress in lualine
            gitsigns-nvim
            vim-sleuth # Automatically adjusts indentation settings
            mini-nvim # Library of mini plugins
          ];
          extra = with pkgs.vimPlugins; [
            fidget-nvim # lualine-lsp-progress
            which-key-nvim # Displays avaiable keybindings.
            ts-comments-nvim # Treesitter-powered commenting plugin
            undotree # Visualize undo history
            indent-blankline-nvim # Adds indentation guides
            vim-startuptime # Measure startup time for Vim
            toggleterm-nvim # Terminal management plugin
            alpha-nvim # Fast and fully customizable greeter for neovim
            flash-nvim # Navigate your code with search labels
            trouble-nvim # Pretty diagnostics, references, telescope results, quickfix and location list
            todo-comments-nvim # Highlight and search for todo comments
            bufferline-nvim # Buffer line with tabpage integration
            snacks-nvim # Collection of small, useful utilities by folke
            noice-nvim # Modern UI for messages, cmdline and popupmenu
            neogit # Magit-like Git interface for Neovim
            diffview-nvim # Single tabpage interface for easily cycling through diffs
            # If it was included in your flake inputs as plugins-hlargs,
            # this would be how to add that plugin in your config.
            # pkgs.neovimPlugins.hlargs
            claude-code-nvim # Integration with Claude Code CLI
          ];
        };
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # <- this would be included if any of the subcategories of general are
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          default = {
            CATTESTVARDEFAULT = "It worked!";
          };
          subtest1 = {
            CATTESTVAR = "It worked!";
          };
          subtest2 = {
            CATTESTVAR3 = "It didn't work!";
          };
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      # do not forget to set `hosts.python3.enable` in package settings

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        general = [(_: [])];
      };

      # see :help nixCats.flake.outputs.categoryDefinitions.default_values
      # this will enable test.default and debug.default
      # if any subcategory of test or debug is enabled
      # WARNING: use of categories argument in this set will cause infinite recursion
      # The categories argument of this function is the FINAL value.
      # You may use it in any of the other sets.
      extraCats = {
        test = [
          ["test" "default"]
        ];
        debug = [
          ["debug" "default"]
        ];
        c = [
          ["debug" "c"] # yes it has to be a list of lists
        ];
        python = [
          ["debug" "default"] # Enable debug plugins for Python
        ];
      };
    };

    # packageDefinitions:

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # the name here is the name of the package
      # and also the default command name for it.
      nixCats = {
        pkgs,
        name,
        ...
      } @ misc: {
        # these also recieve our pkgs variable
        # see :help nixCats.flake.outputs.packageDefinitions
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # The name of the package, and the default launch name,
          # and the name of the .desktop file, is `nixCats`,
          # or, whatever you named the package definition in the packageDefinitions set.
          # WARNING: MAKE SURE THESE DONT CONFLICT WITH OTHER INSTALLED PACKAGES ON YOUR PATH
          # That would result in a failed build, as nixos and home manager modules validate for collisions on your path
          aliases = ["vim" "nvim"];

          # explained below in the `regularCats` package's definition
          # OR see :help nixCats.flake.outputs.settings for all of the settings available
          wrapRc = true;
          configDirName = "az-nvim";
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        # enable the categories you want from categoryDefinitions
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          lua = true;
          nix = true;
          python = true;
          json = true;
          file_navigation = true;
          test = {
            subtest1 = true;
          };

          # enabling this category will enable the c category,
          # and ALSO debug.c and debug.default due to our extraCats in categoryDefinitions.
          c = true;
          latex = true;

          # this does not have an associated category of plugins,
          # but lua can still check for it
          lspDebugMode = false;
          # you could also pass something else:
          # see :help nixCats
          themer = true;
          colorscheme = "tokyonight";
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
        };
      };
      regularCats = {pkgs, ...} @ misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # IMPURE PACKAGE: normal config reload
          # include same categories as main config,
          # will load from vim.fn.stdpath('config')
          wrapRc = false;
          # or tell it some other place to load
          # unwrappedCfgPath = "/some/path/to/your/config";

          # configDirName: will now look for nixCats-nvim within .config and .local and others
          # this can be changed so that you can choose which ones share data folders for auths
          # :h $NVIM_APPNAME
          configDirName = "nixCats-nvim";

          aliases = ["testCat"];

          # If you wanted nightly, uncomment this, and the flake input.
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          # Probably add the cache stuff they recommend too.
        };
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          test = true;
          c = true;
          latex = true;
          lua = true;
          nix = true;
          python = true;
          json = true;
          file_navigation = true;
          lspDebugMode = false;
          themer = true;
          colorscheme = "catppuccin";
        };
        extra = {
          # nixCats.extra("path.to.val") will perform vim.tbl_get(nixCats.extra, "path" "to" "val")
          # this is different from the main nixCats("path.to.cat") in that
          # the main nixCats("path.to.cat") will report true if `path.to = true`
          # even though path.to.cat would be an indexing error in that case.
          # this is to mimic the concept of "subcategories" but may get in the way of just fetching values.
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
          # yes even tortured inputs work.
          theBestCat = "says meow!!";
          theWorstCat = {
            thing'1 = ["MEOW" '']]' ]=][=[HISSS]]"[[''];
            thing2 = [
              {
                thing3 = ["give" "treat"];
              }
              "I LOVE KEYBOARDS"
              (utils.mkLuaInline ''[[I am a]] .. [[ lua ]] .. type("value")'')
            ];
            thing4 = "couch is for scratching";
          };
        };
      };
    };

    defaultPackageName = "nixCats";
    # I did not here, but you might want to create a package named nvim.
    # defaultPackageName is also passed to utils.mkNixosModules and utils.mkHomeModules
    # and it controls the name of the top level option set.
    # If you made a package named `nixCats` your default package as we did here,
    # the modules generated would be set at:
    # config.nixCats = {
    #   enable = true;
    #   packageNames = [ "nixCats" ]; # <- the packages you want installed
    #   <see :h nixCats.module for options>
    # }
    # In addition, every package exports its own module via passthru, and is overrideable.
    # so you can yourpackage.homeModule and then the namespace would be that packages name.
  in
    # you shouldnt need to change much past here, but you can if you wish.
    # but you should at least eventually try to figure out whats going on here!
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions and packageDefinitions
        }
        categoryDefinitions
        packageDefinitions;
      # call it with our defaultPackageName
      defaultPackage = nixCatsBuilder defaultPackageName;

      # this pkgs variable is just for using utils such as pkgs.mkShell
      # within this outputs set.
      pkgs = import nixpkgs {inherit system;};
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will generate a set of all the packages
      # in the packageDefinitions defined above
      # from the package we give it.
      # and additionally output the original as default.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
