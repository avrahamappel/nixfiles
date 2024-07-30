{ pkgs, lib, config, ... }:

let
  cfg = config.programs.skhd;

  hotApps = lib.strings.concatLines (lib.lists.imap1
    (idx: app: ''
      cmd - ${builtins.toString (idx + 1)} : open -a ${builtins.replaceStrings [" "] ["\\ "] app}
    '')
    cfg.hotApps);
in

{
  options.programs.skhd = {
    hotApps = lib.mkOption {
      type = lib.types.addCheck (lib.types.listOf lib.types.str) (val: builtins.length val <= 7);
      default = [ "Alacritty" "Firefox" "Mail" ];
      description = ''
        Up to seven apps to be assigned to hotkeys in the form of:
        cmd - number (index of the app in the list, starting from 2)

        cmd - 1 will automatically be assigned to Finder.
      '';
    };
  };

  config = {
    home.packages = with pkgs; [
      skhd
    ];

    home.file.".config/skhd/skhdrc" = {
      text = ''
        # Open alacritty on cmd - return
        # if there's already an instance running, open new window, otherwise start a new instance
        ctrl + cmd - return : ${config.programs.alacritty.package}/bin/alacritty msg create-window 2>&1 || /usr/bin/open -a ${config.programs.alacritty.package}/Applications/Alacritty.app

        # Application shortcuts
        cmd - 1 : open -a Finder

        ${hotApps}
      '';

      onChange = ''
        # Nix version doesn't seem to pick up changes
        if [[ -f "/tmp/skhd_$USER.pid" ]]; then
          ${pkgs.skhd}/bin/skhd --reload
        fi
      '';
    };

    home.activation.install-skhd = ''
      if [[ ! -f "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist" ]]; then
        echo "Don't forget to install the skhd service!"
        echo '`skhd --install-service`'
      fi
    '';
  };
}
