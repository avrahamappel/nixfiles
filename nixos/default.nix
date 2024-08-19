{ pkgs, ... }:

{
  imports = [
    ./gnome.nix
  ];

  # Latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Driver for Canon PIXMA printer
  services.printing.drivers = [ pkgs.cnijfilter2 ];

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

  # Allow unfree packages (drivers etc.)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
  ];

  # Docs: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nix Helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";

    # This replaces garbage collection
    clean = {
      enable = true;
      dates = "Sun 11:45"; # Fifteen minutes before optimise
      extraArgs = "-keep-since 30d";
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

    # VMs
    quickemu
    spice-gtk
  ];

  # Generally I don't need a firewall against the local network
  networking.firewall.enable = false;

  # Make /bin/bash available
  system.activationScripts.binbash = {
    deps = [ "binsh" ];
    text = ''
      ln -s -f /bin/sh /bin/bash
    '';
  };

  # Guest user account
  fileSystems."/home/guest" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=4G" "mode=777" ];
  };
  users.users.guest = {
    isNormalUser = true;
    description = "Guest";
    hashedPassword = "";
  };

  # Enable forwarding USB devices to virtual machines via SPICE.
  security.polkit.enable = true;
  security.wrappers.spice-client-glib-usb-acl-helper = {
    owner = "root";
    group = "root";
    setuid = true;
    source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
  };
}
