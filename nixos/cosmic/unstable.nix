{ lib, pkgs-unstable, modulesPath, ... }:

let
  nixpkgs-unstable-flake = (builtins.fromJSON
    (builtins.readFile ../../flake.lock)).nodes.nixpkgs-unstable.locked;
  nixpkgs-unstable = fetchTree {
    inherit (nixpkgs-unstable-flake) type narHash lastModified rev url;
  };

in

{
  # Swap in the unstable version of the comsic module
  disabledModules = [ "${modulesPath}/services/desktop-managers/cosmic.nix" ];
  imports = [ "${nixpkgs-unstable}/nixos/modules/services/desktop-managers/cosmic.nix" ];

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
          "cosmic-files"
          "cosmic-greeter"
          "cosmic-icons"
          "cosmic-idle"
          "cosmic-initial-setup"
          "cosmic-launcher"
          "cosmic-monitor"
          "cosmic-notifications"
          "cosmic-osd"
          "cosmic-panel"
          "cosmic-player"
          "cosmic-protocols"
          "cosmic-randr"
          "cosmic-screenshot"
          "cosmic-session"
          "cosmic-settings"
          "cosmic-settings-daemon"
          "cosmic-store"
          "cosmic-term"
          "cosmic-wallpapers"
          "cosmic-workspaces-epoch"
          "xdg-desktop-portal-cosmic"
        ];
      in

      lib.genAttrs cosmicPkgNames (name: pkgs-unstable.${name})
    )
  ];
}
