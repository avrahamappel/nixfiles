{ config, pkgs, ... }:

{
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    # Static files to link into home dir
    # TODO use xdg.config
    file.".config/codespell/ignore-words".source = ./codespell/ignore-words;

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Overlays for nixpkgs
  nixpkgs.overlays = [
  ];

  # Packages that should be installed to the user profile.
  # To search by name, run:
  # $ nix-env -qaP | grep wget
  home.packages = with pkgs; [
    # LSPs
    # TODO when this makes it to stable remove this import
    (import (builtins.getFlake "nixpkgs/nixos-unstable") { }).lemminx
    lua-language-server
    nil
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    rnix-lsp
    taplo

    # Fonts
    ubuntu_font_family

    # Utilities
    codespell # Used by null-ls to provide smarter spell checking
    diffr # Used by my git config for interactive diffs
    gron # When I have no patience for JQ
    ripgrep # Awesome searching tool, and also used by fzf.vim
    nixpkgs-fmt # Used by nil for formatting
    shellcheck # Used by the bash LSP
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

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

    # Terminal configuration
    kitty = {
      enable = true;
      font = {
        package = pkgs.source-code-pro;
        name = "Source Code Pro";
        size = 14;
      };
      shellIntegration.mode = "no-cursor";
      settings = {
        background_opacity = "0.75";
        cursor_blink_interval = 0;
        enable_audio_bell = false;
      };
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
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-update
      ]);
    };

    browserpass = {
      enable = true;
      browsers = [ "chrome" "firefox" ];
    };

    # Other stuff
    tmux = {
      enable = true;
      terminal = "xterm-256color";
      shortcut = "z";
      keyMode = "vi";
      mouse = true;
      extraConfig = ''
        set-option -g status off
        set-option -g set-titles on
        set-option -g set-titles-string '#{session_name} (tmux)'
      '';
    };

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
    darwin.defaults = import ./macos.nix;
  };
}
