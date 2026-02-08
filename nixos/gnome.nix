{ pkgs, lib, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Gnome extensions
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator # Necessary for mailspring icon
    gnomeExtensions.bangs-search # DuckDuckGo bangs in GNOME search
    gnomeExtensions.pip-on-top # Make picture-in-picture stay on top of all windows
    gnomeExtensions.vitals
    gnomeExtensions.night-theme-switcher
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany # Web browser
    geary # Mail client
    gnome-software # Software update center
    gnome-tour
    orca # Screen reader
  ];

  # Workaround for GNOME Nautilus error where unable to view
  # data about audio/video files
  # See https://github.com/NixOS/nixpkgs/issues/53631
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
    lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
    ];

  # Fix Remote Desktop not showing in settings
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  # Default account settings
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface".clock-format = "12h";
        "org/gnome/system/location".enabled = true;
      };
    }
  ];

  # My specific user account settings
  home-manager.users.avraham = { lib, config, ... }: {
    options = {
      hotkeys = {
        media = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable media control hotkeys. Set to false if your keyboard has dedicated media control keys.";
        };
      };
    };

    config = {
      dconf.settings = with lib.hm.gvariant; {
        # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
        "org/gnome/desktop/interface" = {
          clock-format = "12h";
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
          show-battery-percentage = true;
        };

        "org/gnome/desktop/input-settings" = {
          sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "il" ]) ];
        };

        "org/gnome/desktop/notifications" = {
          show-in-lock-screen = false;
        };

        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
          primary-color = "#77767B";
          secondary-color = "#000000";
        };

        "org/gnome/desktop/screensaver" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
          primary-color = "#77767B";
          secondary-color = "#000000";
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        } // lib.optionalAttrs config.hotkeys.media {
          next = [ "F10" ];
          play = [ "F9" ];
          previous = [ "F8" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>Return";
          command = "alacritty";
          name = "Open terminal";
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "pip-on-top@rafostar.github.com"
            "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
            "Vitals@CoreCoding.com"
            "nightthemeswitcher@romainvigier.fr"
            "appindicatorsupport@rgcjonas.gmail.com"
            "bangs-search@suvan"
          ];
          favorite-apps = [
            "firefox-devedition.desktop"
            "Alacritty.desktop"
            "org.gnome.Nautilus.desktop"
            "Mailspring.desktop"
          ];
        };

        "org/gnome/shell/extensions/pip-on-top" = {
          stick = true;
        };

        "org/gnome/shell/extensions/vitals" = {
          hot-sensors = [ "_memory_usage_" "_processor_usage_" "_storage_used_" ];
        };
      };
    };
  };
}
