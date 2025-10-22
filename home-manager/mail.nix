{ pkgs, pkgs-unstable, lib, ... }:

let
  npins = import ../npins;

  mailspringPackages = {
    source = pkgs.linkFarm "mailspring-packages" {
      "Mailspring Automatic Light-Dark Mode" =
        npins."andrewminion/mailspring-automatic-light-dark-mode";
    };
  };
in

{
  home.packages = [ pkgs-unstable.mailspring ];

  home.file.".config/Mailspring/packages" =
    lib.mkIf pkgs.stdenv.isLinux mailspringPackages;

  home.file."Library/Application Support/Mailspring/packages" =
    lib.mkIf pkgs.stdenv.isDarwin mailspringPackages;
}
