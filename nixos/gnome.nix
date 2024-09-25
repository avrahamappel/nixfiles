{ pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Gnome extensions
  environment.systemPackages = with pkgs; [
    # Make picture-in-picture stay on top of all windows
    (gnomeExtensions.pip-on-top.override {
      version = "8"; # Version 7 doesn't work with GNOME 46
      sha256 = "1gwn5wgqhz2nh8icj1byv7kgs8sk16mkzmj2zf7y0svprbl5vf7n";
    })
    gnomeExtensions.vitals
    gnomeExtensions.night-theme-switcher
  ];

  # Don't install Gnome web browser by default
  environment.gnome.excludePackages = with pkgs.gnome; [ epiphany ];

  # Default account settings
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface".clock-format = "12h";
      };
    }
  ];

  # My specific user account settings
  home-manager.users.avraham.dconf.settings = {
    # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
    "org/gnome/Geary" = {
      autoselect = false;
      single-key-shortcuts = true;
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "pip-on-top@rafostar.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "nightthemeswitcher@romainvigier.fr"
      ];
      favorite-apps = [
        "firefox.desktop"
        "Alacritty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Geary.desktop"
      ];
    };

    "org/gnome/shell/extensions/pip-on-top" = {
      stick = true;
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [ "_memory_usage_" "_system_load_1m_" "_processor_usage_" "_storage_used_" ];
    };
  };
}
