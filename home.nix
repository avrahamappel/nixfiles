{ config, pkgs, ... }:

{
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    # Static files to link into home dir
    file = {
      ".config/codespell/ignore-words".text = ''
        responsable
        crate
        hastable
      '';
    };
  };

  # Overlays for nixpkgs
  nixpkgs.overlays = [
    # Adds pkgs.vimExtraPlugins
    # @TODO there is an open PR in m15a/nixpkgs-vim-extra-plugins from this repo
    (builtins.getFlake "github:dearrrfish/nixpkgs-vim-extra-plugins").overlays.default
  ];

  # Packages that should be installed to the user profile.
  # To search by name, run:
  # $ nix-env -qaP | grep wget
  home.packages = with pkgs; [
    # LSPs
    lua-language-server
    nil
    nodePackages.bash-language-server
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
      environment = {
        TERM = "xterm-256color";
      };
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu Mono";
        size = 16;
      };
      shellIntegration.mode = "no-cursor";
      settings = {
        adjust_line_height = 1;
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
      package = pkgs.pass.withExtensions (exts: [ exts.pass-import ]);
    };
    browserpass = {
      enable = true;
      browsers = [ "chrome" ];
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
    darwin.defaults =
      if pkgs.stdenv.isDarwin
      then import ./macos.nix
      else { };

    # Hope this helps until I'm off Lubuntu
    genericLinux.enable = pkgs.stdenv.isLinux;
  };
}
