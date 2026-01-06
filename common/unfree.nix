{ lib, config, ... }:

{
  options.unfreePackages = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    description = "Which unfree packages to allow in this configuration";
  };

  config = lib.mkIf (config.unfreePackages != [ ]) {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.unfreePackages;
  };
}
