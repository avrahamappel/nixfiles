{ pkgs, cosmicLib, ... }:

let
  inherit (import ../../../npins)
    cosmic-manager
    ;

in

with cosmicLib.cosmic;

{
  imports = [
    "${cosmic-manager}/modules"
    ./applet-battery.nix
    ./ext-applet-sysinfo.nix
  ];

  # COSMIC plugins and extra packages
  home.packages = with pkgs; [
    cosmic-ext-applet-weather # Simple weather widget
    gnome-bluetooth # Send files to device via Bluetooth (COSMIC does not have this yet)
  ];

  # COSMIC config
  wayland.desktopManager.cosmic.enable = true;
  wayland.desktopManager.cosmic.applets.app-list = {
    settings.favorites = [
      "firefox-devedition"
      "alacritty"
      "com.system76.CosmicFiles"
      "Mailspring"
      "org.gnome.GTG.Devel"
    ];
  };
  wayland.desktopManager.cosmic.applets.audio = {
    settings.show_media_controls_in_top_panel = true;
  };
  wayland.desktopManager.cosmic.applets.time.settings.show_weekday = true;
  wayland.desktopManager.cosmic.shortcuts = [
    {
      description = mkRON "optional" "Minimize current window";
      key = "Super+N";
      action = mkRON "enum" "Minimize";
    }
    # TODO: shortcuts for Mailspring and GTG etc
    # TODO: media hotkeys
  ];

  wayland.desktopManager.cosmic.panels = [
    # Panel (top bar)
    {
      name = "Panel";
      margin = 0;
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

    # Dock (bottom bar)
    {
      name = "Dock";
      autohide = mkRON "optional" {
        wait_time = 0;
        transition_time = 0;
        handle_size = 4;
        unhide_delay = 0;
      };
      margin = 4;
      plugins_center = mkRON "optional" [
        "com.system76.CosmicAppList"
        "com.system76.CosmicAppletMinimize"
      ];
      plugins_wings = mkRON "optional" (mkRON "tuple" [ [ ] [ ] ]);
    }
  ];

  wayland.desktopManager.cosmic.systemActions = mkRON "map" [
    {
      key = mkRON "enum" "Terminal";
      value = "alacritty";
    }
  ];
  wayland.desktopManager.cosmic.configFile = {
    "com.system76.CosmicTheme.Mode" = {
      version = 1;
      entries.auto_switch = true; # Auto switch dark/light for day/night
    };
    # TODO: disable until we figure out the correct option structure and type
    # "io.github.cosmic_utils.weather-applet" = {
    #   version = 1;
    #   entries = {
    #     use_ip_location = !cfg.manualLocation.enable;
    #   } // lib.optionalAttrs cfg.manualLocation.enable {
    #     latitude = mkRON "raw" cfg.manualLocation.latitude;
    #     longitude = mkRON "raw" cfg.manualLocation.longitude;
    #   };
    # };
  };

  # TODO: Remove unmanaged settings (once I'm confident in these)
  # wayland.desktopManager.cosmic.resetFiles = true;
}
