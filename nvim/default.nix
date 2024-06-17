{ pkgs, lib }:

{
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

  # List of vim plugins to install optionally associated with configuration to be placed in init.vim.
  plugins = with pkgs.vimPlugins; [
    # Nothing wrong with some extra speed
    impatient-nvim

    # Navigation plugins
    fzf-vim
    vim-vinegar
    camelcasemotion

    # Open file:line:column links correctly
    vim-fetch

    # Editor appearance
    vim-gitgutter

    # Code style / syntax plugins
    editorconfig-vim
    vim-prettier
    vim-polyglot
    vim-endwise

    # Plugins that add actions
    emmet-vim
    vim-repeat
    vim-fugitive
    vim-rhubarb
    vim-surround
    vim-abolish
    vim-speeddating

    # Language specific plugins
    markdown-preview-nvim
    rust-tools-nvim
    typescript-nvim
    rust-vim
    vim-rails
    vim-ledger

    # DB Support
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    # Theme plugins
    tokyonight-nvim

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
    nvim-config-local

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
    vim-better-whitespace
  ];

  # Custom vimrc lines.
  extraConfig = ''
    source ${builtins.toString ./init.vim}
    luafile ${builtins.toString ./setup.lua}
  '';

  # Symlink vim to nvim binary.
  vimAlias = true;

  # Alias vimdiff to nvim -d.
  vimdiffAlias = true;

  # Symlink vi to nvim binary.
  viAlias = true;

  defaultEditor = true;
}
