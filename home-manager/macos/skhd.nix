{ pkgs, lib, config, ... }:

let
  cfg = config.services.skhd;

  hotApps = lib.strings.concatLines (lib.lists.imap1
    (idx: app: ''
      cmd - ${builtins.toString idx} : open -a ${builtins.replaceStrings [" "] ["\\ "] app}
    '')
    cfg.hotApps);
in

{
  options.services.skhd = {
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

    config = ''
      # Open alacritty on cmd - return
      # if there's already an instance running, open new window, otherwise start a new instance
      cmd - return : ${config.programs.alacritty.package}/bin/alacritty msg create-window 2>&1 || /usr/bin/open -a ${config.programs.alacritty.package}/Applications/Alacritty.app

      # Application shortcuts
      ${hotApps}
    '';
  };
}
