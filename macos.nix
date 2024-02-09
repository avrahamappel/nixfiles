{ pkgs, lib, ... }:

{
  imports = [ ./home.nix ];

  # Override font size on mac retina screen
  programs.alacritty.settings.font = {
    size = lib.mkForce 15.5;
    offset.x = 1;
  };

  # Standalone needs this 
  nix.package = pkgs.nix;

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
