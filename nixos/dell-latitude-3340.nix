{
  imports = [ ./. ];

  boot.kernelPatches = [
    {
      name = "keyboard-after-suspend-fix";
      patch = ./keyboard-after-suspend-fix.patch;
    }
  ];

  # Some memory tweaks to improve performance hopefully
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 1;
    "vm.dirty_background_ratio" = 2;
    "vm.swappiness" = 100;
  };
  # Make browsers faster
  services.psd.enable = true;

  # Power management
  services.auto-cpufreq.enable = true;
}
