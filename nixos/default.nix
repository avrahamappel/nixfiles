{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  # Latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Driver for Canon PIXMA printer
  services.printing.drivers = [ pkgs.cnijfilter2 ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.avraham = {
      imports = [
        ./dconf.nix
        ../home.nix
      ];
    };
  };

  # Allow unfree packages (drivers etc.)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimization
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  environment.systemPackages = with pkgs; [
    # Must-have
    vim

    # Gnome extensions
    gnomeExtensions.pip-on-top # Make picture-in-picture stay on top of all windows
    gnomeExtensions.vitals

    # Clipboard support
    wl-clipboard
    xclip

    # VMs
    quickemu
    spice-gtk
  ];
  # Don't install Gnome web browser by default
  environment.gnome.excludePackages = with pkgs.gnome; [ epiphany ];

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

  # Gnome accounts defaults
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface".clock-format = "12h";
      };
    }
  ];
}
