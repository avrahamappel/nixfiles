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
    "vm.swappiness" = 80;
  };
  # Make browsers faster
  services.psd.enable = true;
}
