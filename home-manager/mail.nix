{ pkgs, ... }:

let
  npins = import ../npins;
in

{
  home.packages = [ pkgs.mailspring ];

  home.file.".config/Mailspring/packages".source = pkgs.linkFarm "packages" {
    "Mailspring Automatic Light-Dark Mode" =
      npins."andrewminion/mailspring-automatic-light-dark-mode";
  };
}
