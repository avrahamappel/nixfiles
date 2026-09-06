{ lib, pkgs, config, ... }:

let
  cfg = config.cosmic;

  inherit (import ../npins)
    cosmic-ext-applet-sysinfo-src
    cosmic-manager
    ;

  cosmic-battery-applet = pkgs.callPackage ./pkgs/cosmic-battery-applet.nix { };

  cosmic-ext-applet-sysinfo = pkgs.cosmic-ext-applet-sysinfo.overrideAttrs (final: prev: {
    version = "0-unstable-${builtins.substring 0 7 cosmic-ext-applet-sysinfo-src.revision}";
    src = cosmic-ext-applet-sysinfo-src;
    cargoHash = "sha256-xCzrsLQb9k7VcNmt+pyHQk6UdxR0TjdhRz9wPZ4tsEY=";
    cargoDeps = prev.cargoDeps.overrideAttrs (deps: {
      vendorStaging = deps.vendorStaging.overrideAttrs {
        outputHash = final.cargoHash;
      };
    });
  });
in

{
  options.cosmic = with lib.types; {
    enable = lib.mkEnableOption "Enable COSMIC desktop environment";

    manualLocation = {
      enable = lib.mkEnableOption "Enable setting manual location (e.g. for weather)";
      latitude = lib.mkOption { type = oneOf [ float str ]; };
      longitude = lib.mkOption { type = oneOf [ float str ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
    services.system76-scheduler.enable = true;

    # Set GStreamer variable so cosmic-player works
    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
      lib.makeSearchPath "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
        gstreamer.out
        gst-plugins-base
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
        gst-vaapi
      ]);

    services.desktopManager.cosmic.showExcludedPkgsWarning = false;
    environment.cosmic.excludePackages = with pkgs; [
      orca # BH I don't need a screen reader
    ];

    home-manager.users.avraham = { cosmicLib, ... }: with cosmicLib.cosmic; {
      imports = [
        "${cosmic-manager}/modules"
      ];

      # COSMIC plugins and extra packages
      home.packages = with pkgs; [
        cosmic-battery-applet # Show battery percentage (apparently this already exists in latest COSMIC, but nixpkgs is slow to update and I don't want to override all the packages myself)
        cosmic-monitor # System monitor
        cosmic-ext-applet-sysinfo # Simple system info widget
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
              "cosmic-battery-applet" # TODO: remove when COSMIC shows percent
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
        "io.github.cosmic-utils.cosmic-ext-applet-sysinfo" = {
          version = 1;
          entries = {
            include_swap_in_ram = false;
            template = "CPU {cpu_usage} {cpu_temp} | GPU {gpu_usage} | RAM {ram_usage} | Disk {disk_usage}";
            use_mono_font = true;
          };
        };
        "io.github.cosmic_utils.weather-applet" = {
          version = 1;
          entries = {
            use_ip_location = !cfg.manualLocation.enable;
          } // lib.optionalAttrs cfg.manualLocation.enable {
            latitude = mkRON "raw" cfg.manualLocation.latitude;
            longitude = mkRON "raw" cfg.manualLocation.longitude;
          };
        };
      };

      # TODO: Remove unmanaged settings (once I'm confident in these)
      # wayland.desktopManager.cosmic.resetFiles = true;
    };
  };
}
