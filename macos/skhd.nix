{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    skhd
  ];

  home.file.".config/skhd/skhdrc" = {
    text = ''
      # Open alacritty on cmd - return
      # if there's already an instance running, open new window
      ctrl + cmd - return : ${config.programs.alacritty.package}/bin/alacritty msg create-window
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
      ${pkgs.skhd}/bin/skhd --install-service
    fi
  '';
}
