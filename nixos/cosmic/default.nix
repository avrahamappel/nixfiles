{ lib, pkgs, config, ... }:

let
  cfg = config.cosmic;

in

{
  imports = [
    ./unstable.nix
  ];

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

    home-manager.users.avraham = {
      imports = [ ./hmModules ];
    };
  };
}
