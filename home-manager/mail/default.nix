{ pkgs-unstable, lib, config, ... }:

let
  package = pkgs-unstable.mailspring.overrideAttrs {
    postPatch = ''
      echo 'Disabling update notification'
      sed -i 's/updater.getState()/false/' app/internal_packages/notifications/lib/items/update-notification.tsx
    '';
  };
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
