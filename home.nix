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

  # Home Manager documentation
  manual = {
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };

  # Nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      # Docs: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
      experimental-features = [ "nix-command" "flakes" ];
      keep-derivations = true;
      keep-outputs = true;
      access-tokens = builtins.readFile ./access-tokens.txt;
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
    scientifica
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })

    # Utilities
    codespell # Used by null-ls to provide smarter spell checking
    diffr # Used by my git config for interactive diffs
    gron # When I have no patience for JQ
    ripgrep # Awesome searching tool, and also used by fzf.vim
    nixpkgs-fmt # Used by nil for formatting
    shellcheck # Used by the bash LSP
    ttyd # For opening a terminal in the browser while screensharing
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
    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations =
            if pkgs.stdenv.isDarwin then "Buttonless" else "None";
          opacity = 0.75;
          startup_mode = "Maximized";
        };
        font = {
          normal.family = "UbuntuMono Nerd Font";
          size = 16;
        };
        cursor.vi_mode_style.blinking = "On";
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
