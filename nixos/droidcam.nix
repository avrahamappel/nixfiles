{ lib, pkgs, config, ... }:

let
  cfg = config.droidcam;
in

{
  options.droidcam.enable = lib.mkEnableOption "Whether to enable DroidCam support";

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" "snd-aloop" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Android Phone"
      '';
    };

    environment.systemPackages = [ pkgs.droidcam ];
  };
}
