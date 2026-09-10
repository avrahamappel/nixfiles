{ lib, pkgs-unstable, config, ... }:

# Simple system info widget

let
  inherit (import ../../npins)
    cosmic-ext-applet-sysinfo-src
    ;

  upstream = pkgs-unstable.cosmic-ext-applet-sysinfo;

  cosmic-ext-applet-sysinfo = upstream.overrideAttrs (final: prev: {
    version = "0-unstable-${builtins.substring 0 7 cosmic-ext-applet-sysinfo-src.revision}";
    src = cosmic-ext-applet-sysinfo-src;
    cargoHash = "sha256-xCzrsLQb9k7VcNmt+pyHQk6UdxR0TjdhRz9wPZ4tsEY=";
    cargoDeps = prev.cargoDeps.overrideAttrs (deps: {
      vendorStaging = deps.vendorStaging.overrideAttrs {
        outputHash = final.cargoHash;
      };
    });
  });
in

{
  config = lib.mkIf config.cosmic.enable {
    # Warn if my PR landed in upstream nixpkgs
    warnings = lib.optional
      (lib.versionAtLeast upstream.version "0-unstable-2026-08-31")
      "Disk usage info is already in upstream cosmic-ext-applet-sysinfo";

    home.packages = [ cosmic-ext-applet-sysinfo ];

    wayland.desktopManager.cosmic.configFile = {
      "io.github.cosmic-utils.cosmic-ext-applet-sysinfo" = {
        version = 1;
        entries = {
          include_swap_in_ram = false;
          template = "CPU {cpu_usage} {cpu_temp} | GPU {gpu_usage} | RAM {ram_usage} | Disk {disk_usage}";
          use_mono_font = true;
        };
      };
    };
  };
}
