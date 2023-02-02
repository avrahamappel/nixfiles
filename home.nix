{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Packages that should be installed to the user profile.
  # To search by name, run:
  # $ nix-env -qaP | grep wget
  home.packages = with pkgs; [
    # Utilities
    du-dust
    jless
    ripgrep

    # Other
    diffr # Used by my git config for interactive diffs
    shellcheck # Used by the bash LSP

    # LSPs
    nodePackages.bash-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nil
    nixpkgs-fmt
    sumneko-lua-language-server

    # Fonts
    jetbrains-mono
    ubuntu_font_family
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Enable font discovery
  fonts.fontconfig.enable = true;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Use nix-direnv to automatically load nix shells
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Shell configuration
    zsh = import ./zsh { };

    # Git
    git = import ./git.nix { };

    # Editor config
    neovim = import ./nvim { inherit pkgs; };

    # Passwords
    gpg = { enable = true; };
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-import ]);
    };
    browserpass = {
      enable = true;
      browsers = [ "chrome" ];
    };

    # Other stuff
    jq.enable = true;

    tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
  };

  targets = {
    # MacOS
    darwin.defaults =
      if pkgs.stdenv.isDarwin
      then import ./macos.nix
      else { };

    # Hope this helps until I'm off Lubuntu
    genericLinux.enable = pkgs.stdenv.isLinux;
  };
}
