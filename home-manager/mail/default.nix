{ pkgs, lib, config, ... }:

let
  localPackage = pkgs.callPackage ./mailspring.nix { };
  upstreamPackage = pkgs.mailspring;

  package = if pkgs.stdenv.isLinux then localPackage else upstreamPackage;

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
