{ lib, config, ... }:

# Rootless Docker support

{
  options.docker.enable = lib.mkEnableOption "Enable Docker support";

  config = lib.mkIf config.docker.enable {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
