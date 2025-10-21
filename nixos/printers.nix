{ pkgs, lib, config, ... }:

{
  options = {
    brother.enable = lib.mkEnableOption "Brother printers support";
    canon.enable = lib.mkEnableOption "Canon printer support";
    hp.enable = lib.mkEnableOption "HP printer support";
  };

  config = {
    environment.systemPackages = lib.optional config.hp.enable pkgs.hplip;

    services.printing.drivers =
      lib.optional config.canon.enable pkgs.cnijfilter2
      ++ lib.optional config.brother.enable pkgs.brlaser
      ++ lib.optional config.hp.enable pkgs.hplip;

    services.avahi = lib.mkIf config.brother.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
