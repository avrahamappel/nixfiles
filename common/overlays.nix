{ lib, config, ... }:

let
  inherit (import ../npins) irql-vaapi-driver;
in

{
  options = {
    mpvCdSupport = lib.mkEnableOption "Whether to enable MPV to read directly from CD drives, i.e. `mpv cdda://`";
  };

  config = {
    nixpkgs.overlays = [
      # Use a maintained fork of intel-vaapi-driver
      (final: prev: {
        intel-vaapi-driver = prev.intel-vaapi-driver.overrideAttrs {
          version = irql-vaapi-driver.version;
          src = irql-vaapi-driver;
        };
      })
    ]
    ++ lib.optional config.mpvCdSupport (self: super: {
      mpv-unwrapped = super.mpv-unwrapped.override {
        cddaSupport = true;
      };
    });
  };
}
