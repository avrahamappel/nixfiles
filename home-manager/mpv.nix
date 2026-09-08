{ pkgs, lib, ... }:

{
  programs.mpv.enable = true;
  # Enable media controls on Linux
  programs.mpv.scripts = lib.optional pkgs.stdenv.isLinux pkgs.mpvScripts.mpris;

  # Apply graphics settings to mpv
  # See https://nixos.wiki/wiki/Accelerated_Video_Playback#MPV
  programs.mpv.config = lib.optionalAttrs pkgs.stdenv.isLinux {
    hwdec = "auto-safe";
    vo = "gpu";
    profile = "gpu-hq";
    gpu-context = "wayland";
  };
}
