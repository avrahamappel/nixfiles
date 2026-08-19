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

    # Ensure gstreamer is present so cosmic-player works
    environment.systemPackages = with pkgs.gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ];

  };
}
