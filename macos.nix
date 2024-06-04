{ pkgs, lib, ... }:

{
  imports = [ ./home.nix ];

  # Override font size on mac retina screen
  programs.alacritty.settings.font = {
    size = lib.mkForce 15.5;
    offset.x = 1;
  };

  # Standalone needs this 
  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    gc.options = "--delete-older-than 30d";
  };

  # MacOS updates remove this from /etc/zshrc, so just adding it here
  programs.zsh.initExtra = ''
    # Start Nix daemon
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';

  targets.darwin.defaults = {
    NSGlobalDomain = {
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    "com.apple.dashboard" = { mcx-disabled = true; };

    "com.apple.dock" = {
      autohide = true;
      static-only = true;
    };

    "com.apple.finder" = { AppleShowAllFiles = true; };

    "com.apple.LaunchServices" = { LSQuarantine = false; };

    "com.apple.Safari" = { IncludeDevelopMenu = true; };

    "com.apple.screencapture" = { location = "~/Downloads"; };

    NSUserKeyEquivalents = {
      Zoom = "@~=";
    };
  };
}
