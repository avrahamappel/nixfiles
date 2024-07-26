# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  dconf.settings = {
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
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
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
