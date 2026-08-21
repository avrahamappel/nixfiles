{ lib, pkgs, config, ... }:

let
  cfg = config.cosmic;
in

{
  options.cosmic = with lib.types; {
    enable = lib.mkEnableOption "Enable COSMIC desktop environment";

    manualLocation = {
      enable = lib.mkEnableOption "Enable setting manual location (e.g. for weather)";
      latitude = lib.mkOption { type = float; };
      longitude = lib.mkOption { type = float; };
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

    home-manager.users.avraham = { cosmicLib, ... }: {
      imports = [
        ((import ../npins).cosmic-manager + "/modules")
      ];

      # COSMIC plugins and extra packages
      home.packages = with pkgs; [
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
      # wayland.desktopManager.cosmic.shortcuts = [
      #   # TODO: shortcuts for Mailspring and GTG etc
      #   # TODO: media hotkeys
      # ];
      # TODO: panel size
      # TODO: dock autohide
      wayland.desktopManager.cosmic.systemActions = cosmicLib.cosmic.mkRON "map" [
        {
          key = cosmicLib.cosmic.mkRON "enum" "Terminal";
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
            template = "CPU {cpu_usage} | GPU {gpu_usage} | RAM {ram_usage}";
            use_mono_font = true;
          };
        };
        "io.github.cosmic_utils.weather-applet" =
          lib.mkIf cfg.manualLocation.enable {
            version = 1;
            entries = {
              latitude = cfg.manualLocation.latitude;
              longitude = cfg.manualLocation.latitude;
              use_ip_location = false;
            };
          };
      };

      # TODO: Remove unmanaged settings (once I'm confident in these)
      # wayland.desktopManager.cosmic.resetFiles = true;
    };
  };
}
