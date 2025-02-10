{ pkgs, lib, ... }:

{
  imports = [
    ../standalone.nix
    ./skhd.nix
  ];

  home.packages = [
    # Bluetooth CLI
    pkgs.blueutil
  ];

  # Override font size on mac retina screen
  programs.alacritty.settings.font = {
    size = lib.mkForce 15.5;
    offset.x = 1;
  };

  # Disable package installation on Mac
  programs.firefox.package = null;
  programs.thunderbird.package = pkgs.runCommand "dummy-thunderbird" {} "mkdir $out";

  # Required for non-Nix Thunderbird
  home.sessionVariables = {
    MOZ_LEGACY_PROFILES = 1;
    MOZ_ALLOW_DOWNGRADE = 1;
  };

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
