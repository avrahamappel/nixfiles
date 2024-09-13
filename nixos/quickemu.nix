{ pkgs, ... }:

# Quickemu VM support
# Not enabled by default

{
  environment.systemPackages = with pkgs; [
    quickemu
    spice-gtk
  ];

  # Enable forwarding USB devices to virtual machines via SPICE.
  security.polkit.enable = true;
  security.wrappers.spice-client-glib-usb-acl-helper = {
    owner = "root";
    group = "root";
    setuid = true;
    source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
  };
}
