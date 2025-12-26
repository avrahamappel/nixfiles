{ pkgs, lib, config, ... }:

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

    # Overlay until next CUPS version is available
    # https://nixpkgs-tracker.ocfox.me/?pr=468820
    nixpkgs.overlays = [
      (self: super: {
        cups = super.cups.overrideAttrs (prev:

          assert prev.version == "2.4.15";

          let
            version = "2.4.16";
          in

          {
            inherit version;
            src = self.fetchurl {
              url = "https://github.com/OpenPrinting/cups/releases/download/v${version}/cups-${version}-source.tar.gz";
              hash = "sha256-AzlYcgS0+UKN0FkuswHewL+epuqNzl2WkNVr5YWrqS0=";
            };
          });
      })
    ];
  };
}
