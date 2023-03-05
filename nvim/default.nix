{ pkgs }:

{
  enable = true;

  # List of vim plugins to install optionally associated with configuration to be placed in init.vim.
  plugins = with pkgs.vimPlugins; [
    # Nothing wrong with some extra speed
    impatient-nvim

    # Navigation plugins
    fzf-vim
    vim-vinegar

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
    vim-commentary
    vim-fugitive
    vim-rhubarb
    vim-surround
    vim-abolish
    vim-speeddating

    # Language specific plugins
    rust-vim

    # Theme plugins
    molokai

    # LSP / TreeSitter / Completion plugins
    nvim-treesitter.withAllGrammars

    cmp-nvim-lsp
    cmp-treesitter
    cmp-vsnip
    nvim-cmp
    nvim-lspconfig
    nvim-treesitter-refactor
    # Not sure if I want this right now
    # lsp_signature-nvim
    SchemaStore-nvim # Adds schemas to json ls
    vim-vsnip
    pkgs.vimExtraPlugins.null-ls-nvim
    plenary-nvim # Required by null-ls
  ];

  # Custom vimrc lines.
  extraConfig = ''
    source ${builtins.toString ./init.vim}
    lua dofile '${builtins.toString ./setup.lua}'
  '';

  # Symlink vim to nvim binary.
  vimAlias = true;

  # Alias vimdiff to nvim -d.
  vimdiffAlias = true;

  # Symlink vi to nvim binary.
  viAlias = true;
}
