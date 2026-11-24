{ cosmicLib, ... }:

let inherit (cosmicLib.cosmic) mkRON;
in

{
  # Set Alacritty as system terminal, so it starts on Super+T
  wayland.desktopManager.cosmic.systemActions = mkRON "map" [
    {
      key = mkRON "enum" "Terminal";
      value = "alacritty";
    }
  ];

  # Minimize window with Super+N
  wayland.desktopManager.cosmic.shortcuts = [
    {
      description = mkRON "optional" "Minimize current window";
      key = "Super+N";
      action = mkRON "enum" "Minimize";
    }
    # TODO: shortcuts for Mailspring and GTG
  ];
}
