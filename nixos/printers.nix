{ pkgs, pkgs-unstable, lib, config, ... }:

# See https://wiki.nixos.org/wiki/Printing

{
  options = {
    brother.enable = lib.mkEnableOption "Brother printers support";
    canon.enable = lib.mkEnableOption "Canon printer support";
    hp.enable = lib.mkEnableOption "HP printer support";
  };

  config = {
    environment.systemPackages = lib.optional config.hp.enable pkgs.hplipWithPlugin;

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ] ++ lib.optional config.canon.enable pkgs.cnijfilter2
      ++ lib.optional config.brother.enable pkgs.brlaser
      ++ lib.optional config.hp.enable pkgs.hplipWithPlugin;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # CUPS-COMPAT
    # Use packages from unstable that have latest CUPS
    # https://nixpkgs-tracker.ocfox.me/?pr=468820
    assertions = [
      {
        assertion = pkgs.cups.version == "2.4.15";
        message = "CUPS is up to date, remove unstable packages";
      }
      {
        assertion = pkgs-unstable.cups.version == "2.4.16";
        message = "Unstable CUPS is not the correct version";
      }
    ];
    services.printing.package = pkgs-unstable.cups;
  };
}
