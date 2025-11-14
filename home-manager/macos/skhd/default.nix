{ pkgs, lib, options, config, ... }:

let
  isHmModule = options ? home;

  cfg = config.services.skhd;

  hotApps = lib.strings.concatLines (lib.lists.imap1
    (idx: app: ''
      cmd - ${builtins.toString idx} : open -a ${builtins.replaceStrings [" "] ["\\ "] app}
    '')
    cfg.hotApps);

  skhdConfig = ''
    # Open alacritty on cmd - return
    # if there's already an instance running, open new window, otherwise start a new instance
    cmd - return : ${cfg.alacrittyPkg}/bin/alacritty msg create-window 2>&1 || /usr/bin/open -a ${cfg.alacrittyPkg}/Applications/Alacritty.app

    # Application shortcuts
    ${hotApps}
  '';

  skhd-zig = pkgs.callPackage (import ./package.nix) { };
in

{
  options.services.skhd = {
    alacrittyPkg = lib.mkOption {
      type = lib.types.package;
      default = if config.programs ? alacritty then config.programs.alacritty.package else pkgs.alacritty;
      description = ''
        The Alacritty package to use when launching Alacritty from skhd.
      '';
    };

    hotApps = lib.mkOption {
      type = lib.types.addCheck (lib.types.listOf lib.types.str) (val: builtins.length val <= 7);
      example = [ "Alacritty" "Firefox" "Mail" ];
      description = ''
        Up to seven apps to be assigned to hotkeys in the form of:
        cmd - number (index of the app in the list, starting from 1)
      '';
    };
  };

  config.services.skhd = {
    enable = true;

    package = skhd-zig;

  } // (if isHmModule then {
    config = skhdConfig;
  } else {
    skhdConfig = skhdConfig;
  });
}
