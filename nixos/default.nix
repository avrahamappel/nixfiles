{ pkgs, ... }:

{
  imports = [
    ./android.nix
    ./docker.nix
    ./intel.nix
    ./gnome.nix
    ./printers.nix
    ./quickemu.nix
    ./wine.nix
  ];

  # Latest Nix cli
  nix.package = pkgs.nixVersions.latest;

  # Latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # My user account
  programs.zsh.enable = true;
  users.users.avraham.shell = pkgs.zsh;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.avraham = {
      imports = [
        ../home-manager
      ];
    };
  };

  # Docs: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nix Helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";

    # This replaces garbage collection
    clean = {
      enable = true;
      dates = "Sun 23:45"; # Fifteen minutes before optimise
      extraArgs = "--keep-since 30d";
    };
  };

  # Optimization
  nix.optimise = {
    automatic = true;
    dates = [ "Mon 00:00" ];
  };

  environment.systemPackages = with pkgs; [
    # Must-have
    vim

    # Clipboard support
    wl-clipboard
  ];

  # NixOS fails to set a default cursor theme, which breaks Rust applications
  # using winit and running on Wayland, such as Alacritty
  # see https://github.com/NixOS/nixpkgs/issues/22652#issuecomment-2222497441
  environment.variables.XCURSOR_THEME = "Adwaita";

  # Generally I don't need a firewall against the local network
  networking.firewall.enable = false;

  # Make /bin/bash available
  system.activationScripts.binbash = {
    deps = [ "binsh" ];
    text = ''
      ln -s -f /bin/sh /bin/bash
    '';
  };
}
