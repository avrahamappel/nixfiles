{ pkgs, pkgs-unstable, cosmicLib, ... }:

let inherit (cosmicLib.cosmic) mkRON;
in

# Panel (top bar) and applet settings

{
  wayland.desktopManager.cosmic.panels = [
    {
      name = "Panel";
      border_radius = 0;
      margin = 0;
      opacity = 1.0;
      size = mkRON "enum" "XS";
      plugins_center = mkRON "optional" [
        "com.system76.CosmicAppletTime"
        "io.github.cosmic_utils.weather-applet"
      ];
      plugins_wings = mkRON "optional" (mkRON "tuple" [
        [
          "io.github.cosmic_utils.sysinfo-applet"
        ]
        [
          "com.system76.CosmicAppletInputSources" # keyboard lang
          "com.system76.CosmicAppletStatusArea" # idk? Contains Mailspring
          "com.system76.CosmicAppletTiling"
          "com.system76.CosmicAppletAudio"
          "com.system76.CosmicAppletBluetooth"
          "com.system76.CosmicAppletNetwork"
          "com.system76.CosmicAppletBattery"
          "com.system76.CosmicAppletNotifications"
          "com.system76.CosmicAppletPower"
        ]
      ]);
    }
  ];

  # Applet settings
  home.packages = [
    pkgs-unstable.cosmic-ext-applet-sysinfo # Simple system info widget
    pkgs.cosmic-ext-applet-weather # Simple weather widget
  ];

  wayland.desktopManager.cosmic.configFile."io.github.cosmic-utils.cosmic-ext-applet-sysinfo" = {
    version = 1;
    entries = {
      include_swap_in_ram = false;
      template = "CPU {cpu_usage} {cpu_temp} | RAM {ram_usage} | Disk {disk_usage}";
      use_mono_font = true;
    };
  };

  # Show weekday in date
  wayland.desktopManager.cosmic.applets.time.settings.show_weekday = true;

  # Weather applet settings
  wayland.desktopManager.cosmic.configFile."io.github.cosmic_utils.weather-applet" = {
    version = 1;
    entries.use_ip_location = true;
  };

  # Show media controls while playing
  wayland.desktopManager.cosmic.applets.audio.settings = {
    show_media_controls_in_top_panel = true;
  };

  # Show battery percentage in panel
  wayland.desktopManager.cosmic.configFile."com.system76.CosmicAppletBattery" = {
    version = 1;
    entries.show_percentage = true;
  };
}
