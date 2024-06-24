{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    skhd
  ];

  home.file.".config/skhd/skhdrc" = {
    text = ''
      # Open alacritty on cmd - return
      # if there's already an instance running, open new window, otherwise start a new instance
      ctrl + cmd - return : ${config.programs.alacritty.package}/bin/alacritty msg create-window 2>&1 || /usr/bin/open -a ${config.programs.alacritty.package}/Applications/Alacritty.app
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
}
