{ pkgs, lib, config, ... }:

{
  options.services.wine = lib.mkEnableOption "Wine and 32-bit graphics support";

  config = lib.mkIf config.services.wine.enable {
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-vaapi-driver
      mesa
    ];

    environment.systemPackages = with pkgs; [
      wine
      winetricks
    ];
  };
}
