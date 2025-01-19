{ lib, ... }:

{
  # Some memory tweaks to improve performance hopefully
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 1;
    "vm.dirty_background_ratio" = 2;
    "vm.swappiness" = 100;
  };
  # Make browsers faster
  services.psd.enable = true;

  # Power management
  # Disabling for now as conflicts with services.power-profiles-daemon,
  # Which is set to true by Gnome
  # If performance gets really bad I'll revisit this
  # services.auto-cpufreq.enable = true;

  # Firmware
  hardware.enableAllFirmware = true;

  # Prune nix store more aggressively
  programs.nh.clean.extraArgs = lib.mkForce "--keep-since 15d";
}
