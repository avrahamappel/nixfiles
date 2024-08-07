{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;

    # Use neovim 0.10
    package =
      let
        pkgs-nvim-0-10 = pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "752d81e439573637074c069df35fda58d4ff73c9";
          hash = "sha256-HXiP93DPRQG27UT+S67uxcoSwkkHt+WVE5YXNOeA+9Q=";
        };
      in
      lib.mkIf (lib.strings.versionOlder pkgs.neovim.version "0.10")
        (pkgs.callPackage "${pkgs-nvim-0-10}/pkgs/by-name/ne/neovim-unwrapped/package.nix"
          {
            inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
            lua = pkgs.luajit;
          });

    # Don't use any providers for now.
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      # Null plugin, just sets leader keys
      # Must be on top so it's the first thing written to init.vim
      {
        plugin = pkgs.stdenv.mkDerivation {
          name = "vim-plugin-set-leader-keys-to-space";
          src = ./empty;
          installPhase = ''
            cp -r $src $out
          '';
        };
        config = ''
          let g:mapleader = ' '
          let g:maplocalleader = ' '
        '';
      }

      {
        # Nothing wrong with some extra speed
        plugin = impatient-nvim;
        type = "lua";
        config = ''
          require 'impatient'
        '';
      }

      ######################
      # Navigation plugins #
      ######################
      {
        plugin = fzf-vim;
        config = /* vim */ ''
          map <leader>p :Files<CR>
          map <leader>b :Buffers<CR>
          map <leader>z :History<CR>
          " FZF does the filtering
          map <leader>f :Rg<CR>
        '';
      }
      vim-vinegar
      {
        plugin = camelcasemotion;
        config = /* vim */ ''
          call camelcasemotion#CreateMotionMappings('c')
        '';
      }

      # Open file:line:column links correctly
      vim-fetch

      # Editor appearance
      vim-gitgutter

      # Code style / syntax plugins
      editorconfig-vim
      vim-polyglot
      vim-endwise

      # Plugins that add actions
      emmet-vim
      vim-repeat
      {
        plugin = vim-fugitive;
        config = /* vim */ ''
          " Shortcut to open fugitive window. 'n' is close to the spacebar
          map <leader>n :Git<CR>
          " Start a fugitive command
          map <leader>g :G
        '';
      }
      vim-rhubarb
      vim-surround
      vim-abolish
      vim-speeddating

      #############################
      # Language specific plugins #
      #############################
      markdown-preview-nvim
      {
        plugin = typescript-nvim;
        type = "lua";
        config = /* lua */ ''
          require("typescript").setup({
              server = {
                  on_attach = on_attach,
                  settings = settings,
              }
          })
        '';
      }
      {
        plugin = rust-tools-nvim
        ;
        type = "lua";
        config = /* lua */ ''
          local rt = require("rust-tools")
          rt.setup({
            server = {
              on_attach = function(_arg, bufnr)
                -- Call normal on_attach function
                on_attach(_arg, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>C", rt.code_action_group.code_action_group, {
                  buffer = bufnr
                })
              end,
              settings = settings
            },
            tools = {
              inlay_hints = {
                only_current_line = true,
              },
            },
          })
        '';
      }
      {
        plugin = rust-vim;
        config = /* vim */ ''
          let g:rustfmt_autosave = 1
        '';
      }
      vim-rails
      vim-ledger

      ##############
      # DB Support #
      ##############
      vim-dadbod
      {
        plugin = vim-dadbod-ui;
        config = /* vim */ ''
          " Shortcut to open db window.
          map <leader>d :DBUI<CR>

          let g:db_ui_debug = 1
          let g:db_ui_force_echo_notifications = 1
          let g:db_ui_table_helpers = {
          \ 'mysql': {
          \   'Count': 'select count(*) from {optional_schema}`{table}`'
          \ },
          \ 'postgres': {
          \   'Count': 'select count(*) from {optional_schema}"{table}"'
          \ },
          \ 'sqlite': {
          \   'Count': 'select count(*) from {table}'
          \ }
          \}
          let g:db_ui_auto_execute_table_helpers = 1

          " Don't add folds in dbout buffers
          autocmd FileType dbout setlocal nofoldenable
        '';
      }
      vim-dadbod-completion

      # Theme plugins
      {
        plugin = tokyonight-nvim;
        config = /* vim */ ''
          colorscheme tokyonight-night
        '';
      }

      # LSP / TreeSitter / Completion plugins
      nvim-treesitter.withAllGrammars

      cmp-nvim-lsp
      cmp-treesitter
      cmp-vsnip
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter-refactor
      lsp_signature-nvim
      SchemaStore-nvim # Adds schemas to json ls
      vim-vsnip
      null-ls-nvim
      plenary-nvim # Required by null-ls

      # Load per-project config
      {
        plugin = nvim-config-local;
        type = "lua";
        config = /* lua */ ''
          require('config-local').setup {
            config_files = { ".vimrc.lua" }
          }
        '';
      }

      # Use direnv
      direnv-vim

      # Mini.nvim (collection of plugins)
      {
        plugin = mini-nvim;
        type = "lua";
        config = /* lua */ ''
          require('mini.ai').setup()
        '';
      }

      # Highlight / clean trailing whitespace
      {
        plugin = vim-better-whitespace;
        config = /* vim */ ''
          let g:better_whitespace_filetypes_blacklist = ['help', 'markdown', 'dbout']
          let g:better_whitespace_skip_empty_lines = 1
          let g:current_line_whitespace_disabled_soft = 1
        '';
      }

    ];

    # Custom config
    extraConfig = builtins.readFile ./init.vim;
    extraLuaConfig = builtins.readFile ./setup.lua;

    # Symlink vim to nvim binary.
    vimAlias = true;

    # Alias vimdiff to nvim -d.
    vimdiffAlias = true;

    # Symlink vi to nvim binary.
    viAlias = true;

    defaultEditor = true;
  };

  home.packages = with pkgs; [
    # LSPs
    lemminx
    lua-language-server
    nil
    nixd
    nixpkgs-fmt # Used by nil for formatting
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vls
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    phpactor
    python3Packages.python-lsp-server
    shellcheck # Used by the bash LSP
    solargraph
    taplo
    typos-lsp
  ];
}
