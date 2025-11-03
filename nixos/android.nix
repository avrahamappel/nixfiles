{ pkgs, lib, config, ... }:

{
  options.android.enable = lib.mkEnableOption "enable ADB/Android dev support";

  config = lib.mkIf config.android.enable {
    # Udev rules
    services.udev.packages = [
      pkgs.android-udev-rules
    ];

    users.users.avraham.packages = [ pkgs.android-tools ];
  };
}
