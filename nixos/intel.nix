{ pkgs, lib, config, ... }:

{
  options.intel.enable = lib.mkEnableOption "Enable older Intel support";

  config = lib.mkIf config.intel.enable {
    # Disable Vulkan on older Intel GPUs
    # see https://bbs.archlinux.org/viewtopic.php?id=306078
    environment.variables.VK_ICD_FILENAMES = "";

    # Enable hardware acceleration for video decoding
    # See https://wiki.nixos.org/wiki/Accelerated_Video_Playback
    hardware.graphics.extraPackages = with pkgs; [
      intel-vaapi-driver
      mesa
    ];
  };
}
