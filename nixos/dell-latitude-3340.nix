{
  imports = [ ./. ];

  boot.kernelPatches = [
    {
      name = "keyboard-after-suspend-fix";
      patch = ./keyboard-after-suspend-fix.patch;
    }
  ];
}
