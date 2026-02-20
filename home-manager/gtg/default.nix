{ lib, pkgs, config, options, ... }:

let
  cfg = config.gtg;
  gtgHome = config.xdg.dataHome + "/gtg";

  package = pkgs.callPackage ./package { };
in

{
  options.gtg.enable = lib.mkEnableOption "Whether to enable GTG";

  config = lib.mkIf cfg.enable {
    home.packages = [ package ];

    home.sessionVariables.GTG_HOME = gtgHome;

    services.git-sync.enable = true;
    services.git-sync.repositories.gtg = {
      path = gtgHome;
      uri = "git@github.com/avrahamappel/gtg.git";
    };

    assertions = [
      {
        assertion = lib.versionOlder "0.7" pkgs.gtg.version;
        message = "Upstream GTG has been updated to 0.7";
      }
      {
        assertion = !(options.programs ? gtg);
        message = "Upstream GTG module exists";
      }
    ];
  };
}
