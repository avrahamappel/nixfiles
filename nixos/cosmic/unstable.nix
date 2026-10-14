{ lib, pkgs, modulesPath, ... }:

let
  nixpkgs-unstable-flake = (builtins.fromJSON
    (builtins.readFile ../../flake.lock)).nodes.nixpkgs-cosmic.locked;
  nixpkgs-unstable = fetchTree {
    inherit (nixpkgs-unstable-flake) type owner repo rev narHash lastModified;
  };
  pkgs-unstable = import nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };

in

{
  # Swap in the unstable version of the cosmic module
  disabledModules = [ "${modulesPath}/services/desktop-managers/cosmic.nix" ];
  imports = [ "${nixpkgs-unstable}/nixos/modules/services/desktop-managers/cosmic.nix" ];

  options = {
    security.polkit.enablePkexecWrapper = lib.mkEnableOption "Dummy enablePkexecWrapper to satisfy unstable cosmic module";
  };

  config = {
    # Overlay unstable cosmic packages
    nixpkgs.overlays = [
      (final: prev:
        let
          cosmicPkgNames = [
            "cosmic-applets"
            "cosmic-app-library"
            "cosmic-bg"
            "cosmic-comp"
            "cosmic-edit"
            "cosmic-ext-applet-sysinfo"
            "cosmic-ext-applet-weather"
            "cosmic-files"
            "cosmic-greeter"
            "cosmic-icons"
            "cosmic-idle"
            "cosmic-initial-setup"
            "cosmic-launcher"
            "cosmic-monitor"
            "cosmic-notifications"
            "cosmic-osd"
            "cosmic-osk"
            "cosmic-panel"
            "cosmic-player"
            "cosmic-protocols"
            "cosmic-randr"
            "cosmic-screenshot"
            "cosmic-session"
            "cosmic-settings"
            "cosmic-settings-daemon"
            "cosmic-sound-theme"
            "cosmic-store"
            "cosmic-term"
            "cosmic-viewer"
            "cosmic-wallpapers"
            "cosmic-workspaces-epoch"
            "xdg-desktop-portal-cosmic"
          ];
        in

        lib.genAttrs cosmicPkgNames (name: pkgs-unstable.${name})
      )
    ];
  };
}
