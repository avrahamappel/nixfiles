{ pkgs-unstable, lib, config, ... }:

let
  inherit (import ../../npins) mailspring-src;

  package =
    if pkgs-unstable.mailspring.version == mailspring-src.version
    then
      pkgs-unstable.mailspring
    else
      pkgs-unstable.mailspring.overrideAttrs {
        version = mailspring-src.version;
        src = mailspring-src;
      };
in

{
  options.mailspring = {
    enable = lib.mkEnableOption "Enable mailspring client";
  };

  config = lib.mkIf config.mailspring.enable {
    home.packages = [ package ];

    xdg.autostart.entries = [
      "${package}/share/applications/Mailspring.desktop"
    ];
  };
}
