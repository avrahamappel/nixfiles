{ pkgs, ... }:

{
  # Udev rules
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  users.users.avraham.packages = [ pkgs.android-tools ];
}
