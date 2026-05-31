{ lib, config, ... }:

{
  options = {
    mpvCdSupport = lib.mkEnableOption "Whether to enable MPV to read directly from CD drives, i.e. `mpv cdda://`";
  };

  config = {
    nixpkgs.overlays = [
      # More overlays here
    ]
    ++ lib.optional config.mpvCdSupport (self: super: {
      mpv-unwrapped = super.mpv-unwrapped.override {
        cddaSupport = true;
      };
    });
  };
}
