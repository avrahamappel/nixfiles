{ pkgs, ... }:

let
  vim-afterimage = (import ../../npins).vim-afterimage;
in

{
  programs.neovim = {
    enable = true;

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

      ######################
      # Navigation plugins #
      ######################
      {
        plugin = telescope-nvim;
        config = /* vim */ ''
          map <leader>p :Telescope find_files<CR>
          map <leader>b :Telescope buffers sort_mru=true<CR>
          map <leader>z :Telescope oldfiles<CR>
          map <leader>f :Telescope live_grep<CR>
        '';
      }
      {
        plugin = telescope-fzf-native-nvim;
        type = "lua";
        config = /* lua */ ''
          local telescope = require('telescope')
          telescope.setup()
          telescope.load_extension('fzf')
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
      # {
      #   plugin = typescript-nvim;
      #   type = "lua";
      #   config = /* lua */ ''
      #     require("typescript").setup({
      #         server = {
      #             on_attach = on_attach,
      #             settings = settings,
      #         }
      #     })
      #   '';
      # }
      {
        plugin = rustaceanvim;
        type = "lua";
        config = /* lua */ ''
          vim.g.rustaceanvim = {
            server = {
              -- TODO: disabling keymaps for now until I learn the plugin better
              -- on_attach = function(_arg, bufnr)
              --   -- Call normal on_attach function
              --   on_attach(_arg, bufnr)
              --   -- Hover actions
              --   vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
              --   -- Code action groups
              --   vim.keymap.set("n", "<Leader>C", rt.code_action_group.code_action_group, {
              --     buffer = bufnr
              --   })
              -- end,
              default_settings = settings
            },
          }
        '';
      }
      {
        plugin = rust-vim;
        config = /* vim */ ''
          let g:rustfmt_autosave = 1
        '';
      }
      vim-rails

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
      plenary-nvim

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

      # Load dotenv variables
      vim-dotenv

      # Load direnv variables
      direnv-vim

      # Dispatch commands asynchronously
      vim-dispatch
      vim-dispatch-neovim

      vim-eunuch # UNIX filesystem utils shortcuts

      # Edit image files in vim
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          src = vim-afterimage;
          pname = vim-afterimage.repository.repo;
          version = vim-afterimage.version;
          meta.homepage = "https://github.com/tpope/vim-afterimage";
        };
      }

      # Mini.nvim (collection of plugins)
      {
        plugin = mini-nvim;
        type = "lua";
        config = /* lua */ ''
          require('mini.ai').setup()
        '';
      }

      ###################
      # Debugging (DAP) #
      ###################
      {
        plugin = nvim-dap;
        # .overrideAttrs (prev: {
        #   # Include Xdebug for PHP debugging
        #   dependencies = [ pkgs.vscode-extensions.xdebug.php-debug ];
        # });
        type = "lua";
        config = /* lua */ ''
          local dap = require('dap')

          -- DAP keymaps
          vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
          vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
          vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
          vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
          -- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
          -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
          -- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
          -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
          -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

          -- Xdebug setup
          dap.adapters.php = {
            type = 'executable',
            command = 'node',
            args = { '${pkgs.vscode-extensions.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js' },
          }
          dap.configurations.php = {
            {
              type = 'php',
              request = 'launch',
              name = 'Listen for Xdebug',
              stopOnEntry = true,
            },
          }
          function RegisterXdebugPathMappings(mappings)
            dap.configurations.php[1].pathMappings = mappings
          end
        '';
      }
      # {
      #   plugin = nvim-dap-ui;
      #   type = "lua";
      #   config = /* lua */ ''
      #     -- vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      #     --   require('dap.ui.widgets').hover()
      #     -- end)
      #     -- vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      #     --   require('dap.ui.widgets').preview()
      #     -- end)
      #     -- vim.keymap.set('n', '<Leader>df', function()
      #     --   local widgets = require('dap.ui.widgets')
      #     --   widgets.centered_float(widgets.frames)
      #     -- end)
      #     -- vim.keymap.set('n', '<Leader>ds', function()
      #     --   local widgets = require('dap.ui.widgets')
      #     --   widgets.centered_float(widgets.scopes)
      #     -- end)
      #   '';
      # }
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
    nixd
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    python3Packages.python-lsp-server
    shellcheck # Used by the bash LSP
    taplo
    typos-lsp

    # Used by vim-afterimage
    antiword
    pdftk
  ];
}
