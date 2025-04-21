{ pkgs, lib, config, ... }:

{
  options = {
    brother.enable = lib.mkEnableOption "Brother MFC-7360N printer support";
  };

  config = {
    services.printing.drivers = [ pkgs.cnijfilter2 ]
      ++ lib.optional config.brother.enable pkgs.brlaser;

    services.avahi = lib.mkIf config.brother.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
