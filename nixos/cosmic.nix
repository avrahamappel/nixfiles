{ lib, pkgs, config, ... }:

let
  cfg = config.cosmic;
in

{
  options.cosmic = {
    enable = lib.mkEnableOption "Enable COSMIC desktop environment";
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

    # COSMIC plugins
    home-manager.users.avraham.home.packages = with pkgs; [
      cosmic-monitor # System monitor
      cosmic-ext-applet-sysinfo # Simple system info widget
      cosmic-ext-applet-weather # Simple weather widget
      gnome-bluetooth # Send files to device via Bluetooth (COSMIC does not have this yet)
    ];
  };
}
