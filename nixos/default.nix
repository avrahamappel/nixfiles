{ pkgs, ... }:

{ 
  imports = [ <home-manager/nixos> ];

  # Driver for Canon PIXMA printer
  services.printing.drivers = [ pkgs.cnijfilter2 ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.avraham = {
      imports = [ ../home.nix ];
    };
  };

  # Allow unfree packages (drivers etc.)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # Source: https://nixos.wiki/wiki/GNOME#Dynamic_triple_buffering
    # Hopefully this gets merged soon so I don't have to keep on top of it
    (final: prev: {
      gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchgit {
            url = "https://gitlab.gnome.org/vanvugt/mutter.git";
            # GNOME 45: triple-buffering-v4-45
            rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
            sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
          };
        });
      });
    })
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.pip-on-top # Make picture-in-picture stay on top of all windows
    wl-clipboard
    xclip
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
}
