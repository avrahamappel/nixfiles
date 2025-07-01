{ pkgs, lib, ... }:

{
  imports = [
    ./wine.nix
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
  # Disabling for now as conflicts with services.power-profiles-daemon,
  # Which is set to true by Gnome
  # If performance gets really bad I'll revisit this
  # services.auto-cpufreq.enable = true;

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # Prune nix store more aggressively
  programs.nh.clean.extraArgs = lib.mkForce "--keep-since 10d";

  # Login with Yubikey
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # Disable Vulkan on older Intel GPUs
  # see https://bbs.archlinux.org/viewtopic.php?id=306078
  environment.variables.VK_ICD_FILENAMES = "";

  # Enable hardware acceleration for video decoding
  # See https://wiki.nixos.org/wiki/Accelerated_Video_Playback
  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    mesa
  ];
  home-manager.users.avraham.programs.mpv.config = {
    hwdec = "auto-safe";
    vo = "gpu";
    profile = "gpu-hq";
    gpu-context = "wayland";
  };

  # Don't suspend on lid close if an SSH session is active
  systemd.services.suspend-ssh-check = {
    description = "Prevent suspend when SSH sessions are active";
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ./check_ssh.sh;
      RemainAfterExit = true;
      User = "root";
      ProtectSystem = "strict"; # Makes the system read-only
      ProtectHome = true; # Restricts access to user home directories
    };
  };
}
