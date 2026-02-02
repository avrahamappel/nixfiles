{ pkgs, pkgs-unstable, lib, config, ... }:

let
  npins = import ../../npins;

  mailspringPackages = pkgs.linkFarm "mailspring-packages" {
    "Mailspring Automatic Light-Dark Mode" =
      npins."andrewminion/mailspring-automatic-light-dark-mode";
  };

  package = pkgs-unstable.callPackage ./mailspring.nix { };
  upstream-package = pkgs-unstable.mailspring;

  assertions = [
    {
      assertion = !lib.versionAtLeast upstream-package.version package.version;
      message = "Mailspring is already up to date";
    }
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    {
      assertion = !builtins.any (p: lib.getName p == "libnotify")
        upstream-package.runtimeDependencies;
      message =
        "`libnotify` has already been added to Mailspring's runtime dependencies";
    }
    {
      assertions = builtins.match "libEGL" upstream-package.postFixup == null;
      message = "https://github.com/NixOS/nixpkgs/pull/282748 has been merged, need to rework my fix";
    }
  ];

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
    inherit assertions;

    home.packages = [ package ];

    home.file.${pluginPath}.source = mailspringPackages;

    xdg.autostart.entries = [
      "${package}/share/applications/Mailspring.desktop"
    ];
  };
}
