{ lib, pkgs-unstable, config, ... }:

# Simple system info widget

{
  home-manager.users.avraham = lib.mkIf config.cosmic.enable {
    home.packages = [ pkgs-unstable.cosmic-ext-applet-sysinfo ];

    wayland.desktopManager.cosmic.configFile = {
      "io.github.cosmic-utils.cosmic-ext-applet-sysinfo" = {
        version = 1;
        entries = {
          include_swap_in_ram = false;
          template = "CPU {cpu_usage} {cpu_temp} | RAM {ram_usage} | Disk {disk_usage}";
          use_mono_font = true;
        };
      };
    };
  };
}
