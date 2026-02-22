{ pkgs, pkgs-unstable, lib, config, ... }:

let
  npins = import ../../npins;

  mailspringPackages = pkgs.linkFarm "mailspring-packages" {
    "Mailspring Automatic Light-Dark Mode" =
      npins."andrewminion/mailspring-automatic-light-dark-mode";
  };

  localPackage = pkgs-unstable.callPackage ./mailspring.nix { };
  upstreamPackage = pkgs-unstable.mailspring;

  package = if pkgs.stdenv.isLinux then localPackage else upstreamPackage;

  pluginPath =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/Mailspring/packages"
    else ".config/Mailspring/packages";
in

{
  options.mailspring = {
    enable = lib.mkEnableOption "Enable mailspring client";
  };

  config = lib.mkIf config.mailspring.enable {
    home.packages = [ package ];

    home.file.${pluginPath}.source = mailspringPackages;

    xdg.autostart.entries = [
      "${package}/share/applications/Mailspring.desktop"
    ];
  };
}
