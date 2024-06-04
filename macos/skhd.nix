{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    skhd
  ];

  home.file.".config/skhd/skhdrc" = {
    text = ''
      # Open alacritty on cmd - return
      # if there's already an instance running, open new window
      cmd - return : ${config.programs.alacritty.package}/bin/alacritty msg create-window
    '';
  };

  home.activation.install-skhd = ''
    if [[ ! -f "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist" ]]; then
      ${pkgs.skhd}/bin/skhd --install-service
    fi
  '';
}
