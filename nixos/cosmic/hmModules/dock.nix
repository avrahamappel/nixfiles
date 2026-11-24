{ cosmicLib, ... }:

let inherit (cosmicLib.cosmic) mkRON;
in

{
  # Dock declaration
  wayland.desktopManager.cosmic.panels = [
    {
      name = "Dock";
      anchor = mkRON "enum" "Bottom";
      autohide = mkRON "enum" "OnOverlap";
      autohide_behavior = {
        wait_time = 0;
        transition_time = 0;
        handle_size = 4;
        unhide_delay = 0;
      };
      expand_to_edges = false;
      margin = 4;
      opacity = 1.0;
      plugins_center = mkRON "optional" [
        "com.system76.CosmicAppList"
        "com.system76.CosmicAppletMinimize"
      ];
      plugins_wings = mkRON "optional" (mkRON "tuple" [ [ ] [ ] ]);
    }
  ];

  # Favorite apps to show in the Dock
  wayland.desktopManager.cosmic.applets.app-list.settings.favorites = [
    "firefox-devedition"
    "alacritty"
    "com.system76.CosmicFiles"
    "Mailspring"
    "org.gnome.GTG.Devel"
  ];
}
