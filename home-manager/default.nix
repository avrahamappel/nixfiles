{ pkgs, ... }:

{
  imports = [
    ./copilot.nix
    ./firefox
    ./mail.nix
    ./terminal.nix
    ./zsh
    ./git.nix
    ./nvim
    ./passwords.nix
    ./hledger.nix
    ./ssh.nix
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
      nerd-fonts.ubuntu-mono 

      npins # Quick and easy pinned sources for Nix

      # Utilities
      ddgr # Query duckduckgo from command line
      du-dust # Intuitive disk usage
      gron # When I have no patience for JQ
      toastify # Send ad-hoc notifications

      # Media
      ffmpeg
      imagemagick

      # QR utilities
      qrcp # Uses QR code to transfer files between devices
      qrtool # Decode QR codes, even from image files
    ] ++ lib.optionals stdenv.isLinux [
      # This is currently marked broken on MacOS
      # It needs the following darwin.apple_sdk.frameworks in buildInputs:
      # AppKit AVFoundation CoreMedia
      # Even when compiled though, it fails with the following error (at least on M1 Macs):
      # Could not set device property CameraFormat with value 1920x1080@15FPS, NV12 Format: Not Found/Rejected/Unsupported
      # May be related: https://github.com/l1npengtul/nokhwa/issues/100
      qrscan # Scan QR codes using system camera (from terminal! with a preview!)
    ];
  };

  # Home Manager documentation
  manual.manpages.enable = true;

  # Nix settings
  nix = {
    settings = {
      # Docs: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
      experimental-features = [ "nix-command" "flakes" ];
    };

    # Include local access-tokens
    extraOptions = ''
      !include access-tokens.conf
    '';
  };

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

    # This helps getting apps to show up on some systems
    # as it generates .profile
    bash.enable = true;

    # Other stuff
    fd.enable = true;

    jq = {
      enable = true;
      colors = {
        # Reset to jq's default colors
        null = "0;90";
        false = "0;39";
        true = "0;39";
        numbers = "0;39";
        strings = "0;32";
        arrays = "1;39";
        objects = "1;39";
        objectKeys = "1;34";
      };
    };

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

  # Git sync
  # Individual repo settings in sub-modules
  services.git-sync.enable = true;
}
