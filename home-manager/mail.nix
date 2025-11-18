{ pkgs, pkgs-unstable, lib, ... }:

let
  npins = import ../npins;

  mailspringPackages = {
    source = pkgs.linkFarm "mailspring-packages" {
      "Mailspring Automatic Light-Dark Mode" =
        npins."andrewminion/mailspring-automatic-light-dark-mode";
    };
  };

  basePackage = pkgs-unstable.mailspring;

  mailspring =
    if pkgs.stdenv.isDarwin
    then basePackage else
      basePackage.overrideAttrs (prev:
        # Assert runtimeDependencies does not already contain libnotify
        assert !builtins.any (p: lib.getName p == "libnotify") prev.runtimeDependencies;
        {
          runtimeDependencies = prev.runtimeDependencies ++ [ pkgs.libnotify ];
        });
in

{
  home.packages = [ mailspring ];

  home.file.".config/Mailspring/packages" =
    lib.mkIf pkgs.stdenv.isLinux mailspringPackages;

  home.file."Library/Application Support/Mailspring/packages" =
    lib.mkIf pkgs.stdenv.isDarwin mailspringPackages;
}
