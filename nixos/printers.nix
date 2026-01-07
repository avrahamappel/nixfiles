{ pkgs, pkgs-unstable, lib, config, ... }:

# See https://wiki.nixos.org/wiki/Printing

let
  brotherName = "Brother";
  hpDeskjetName = "HP_DeskJet_2800_series";
in

{
  options = {
    brother.enable = lib.mkEnableOption "Brother printer support";
    hp.enable = lib.mkEnableOption "HP printer support";
  };

  config = {
    services.printing = {
      enable = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # PRINTERS
    hardware.printers.ensureDefaultPrinter =
      if config.hp.enable then
        hpDeskjetName
      else if config.brother.enable then
        brotherName
      else
        null;

    hardware.printers.ensurePrinters = (lib.optional config.hp.enable {
      name = hpDeskjetName;
      description = "HP Deskjet 2855e";
      deviceUri = "ipp://HP246A0EFC5F37.local:631/ipp/print";
      model = "everywhere";
      ppdOptions = {
        PageSize = "Custom.8.5x11";
      };
    }) ++ (lib.optional config.brother.enable {
      name = brotherName;
    });

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
