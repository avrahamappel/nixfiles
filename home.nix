{ pkgs, ... }:

{
  imports = [
    ./zsh
    ./nvim
    ./git.nix
  ];

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
    enableNixpkgsReleaseCheck = true;

    # TODO move aliases here

    # Packages that should be installed to the user profile.
    # To search by name, run:
    # $ nix-env -qaP | grep wget
    packages = with pkgs; [
      # Fonts
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "UbuntuMono" ]; })

      # Utilities
      ddgr # Query duckduckgo from command line
      du-dust # Intuitive disk usage
      gron # When I have no patience for JQ

      # QR utilities
      qrcp # Uses QR code to transfer files between devices
      qrtool # Decode QR codes, even from image files
      zbar # `zbarcam` decodes from webcam stream (only on linux)
    ];
  };

  # Home Manager documentation
  manual.manpages.enable = true;

  # Nix settings
  nix = {
    settings = {
      # Docs: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
      experimental-features = [ "nix-command" "flakes" ];
      keep-derivations = true;
      keep-outputs = true;
      access-tokens =
        if builtins.pathExists ./access-tokens.txt then
          builtins.readFile ./access-tokens.txt else "";
    };
  };

  # Overlays for nixpkgs
  nixpkgs.overlays = [
  ];

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
          opacity = 0.75;
          decorations = "None";
          startup_mode = "Maximized";
        };
        font = {
          normal.family = "UbuntuMono Nerd Font";
          size = 12.5;
        };
        cursor.vi_mode_style.blinking = "On";
        keyboard.bindings = (pkgs.lib.optional pkgs.stdenv.isLinux {
          key = "N";
          mods = "Shift|Control";
          action = "CreateNewWindow";
        });
      };
    };

    # This helps getting apps to show up on some systems
    # as it generates .profile
    bash.enable = true;

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
      browsers = [ "firefox" ];
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
    mpv.enable = true;
    ripgrep.enable = true;

    tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
