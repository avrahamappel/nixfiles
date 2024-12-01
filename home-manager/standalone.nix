{ pkgs, config, ... }:

# Configuration for using home-manager outside of NixOS

{
  imports = [ ./. ];

  nix.package = pkgs.nixVersions.latest;

  programs.nh = {
    enable = true;
    flake = config.home.homeDirectory + "/.config/home-manager";
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };

  # MacOS updates remove this from /etc/zshrc
  programs.zsh.initExtra = ''
    # Start Nix daemon
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';

  programs.command-not-found.enable = true;
}
