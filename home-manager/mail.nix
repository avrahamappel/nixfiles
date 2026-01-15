{ pkgs, pkgs-unstable, lib, config, ... }:

let
  npins = import ../npins;

  mailspringPackages = pkgs.linkFarm "mailspring-packages" {
    "Mailspring Automatic Light-Dark Mode" =
      npins."andrewminion/mailspring-automatic-light-dark-mode";
  };

  # Mailspring is very noisy about available updates,
  # therefore we always pull it from pkgs-unstable
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
    home.packages = [ mailspring ];

    home.file.${pluginPath}.source = mailspringPackages;

    xdg.autostart.entries = [ "${mailspring}/share/applications/Mailspring.desktop" ];
  };
}
