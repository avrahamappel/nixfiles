{ pkgs, ... }:

let
  inherit (import ../../../npins)
    cosmic-manager
    ;
in

{
  imports = [
    "${cosmic-manager}/modules"
    ./dock.nix
    ./panel.nix
    ./shortcuts.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [
    gnome-bluetooth # Send files to device via Bluetooth (COSMIC does not have this yet)
    gnome-disk-utility # GNOME disk gui
    simple-scan # GNOME document scanner
  ];

  # Enable configuring cosmic with `cosmic-manager`
  wayland.desktopManager.cosmic.enable = true;
  # Remove unmanaged settings
  wayland.desktopManager.cosmic.resetFiles = true;
}
