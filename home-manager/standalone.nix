{ pkgs, config, ... }:

# Configuration for using home-manager outside of NixOS

{
  imports = [ ./. ];

  nix.package = pkgs.nixVersions.latest;

  # Make nh available
  # There will be a module for this in HM 24.11
  # https://github.com/nix-community/home-manager/pull/5304
  home.packages = with pkgs; [ nh ];

  # Set the flake path so nh knows what to update
  home.sessionVariables.FLAKE = config.home.homeDirectory + "/.config/home-manager";

  # MacOS updates remove this from /etc/zshrc
  programs.zsh.initExtra = ''
    # Start Nix daemon
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';

  programs.command-not-found.enable = true;
}
