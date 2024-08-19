{ pkgs, ... }:

# Configuration for using home-manager outside of NixOS

{
  imports = [ ./. ];

  nix.package = pkgs.nix;

  # Make nh available
  # There's an open PR with a module for this
  # https://github.com/nix-community/home-manager/pull/5304
  home.packages = with pkgs; [ nh ];

  # MacOS updates remove this from /etc/zshrc
  programs.zsh.initExtra = ''
    # Start Nix daemon
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';

  programs.command-not-found.enable = true;
}
