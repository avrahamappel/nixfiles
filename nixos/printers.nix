{ pkgs, lib, config, ... }:

{
  options = {
    brother.enable = lib.mkEnableOption "Brother printers support";
    canon.enable = lib.mkEnableOption "Canon printer support";
  };

  config = {
    services.printing.drivers =
      lib.optional config.canon.enable pkgs.cnijfilter2
      ++ lib.optional config.brother.enable pkgs.brlaser;

    services.avahi = lib.mkIf config.brother.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
