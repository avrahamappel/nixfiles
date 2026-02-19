{ lib, pkgs, config, options, ... }:

let
  cfg = config.gtg;
  gtgHome = config.xdg.dataHome + "/gtg";

  package = pkgs.gtg.overridePythonAttrs {
    postPatch = ''
      cat <<PYTHON > GTG/__init__.py
      import gi
      gi.require_version('Gtk', '3.0')
      PYTHON
    '';
  };
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
        assertion = !(options.programs ? gtg);
        message = "Upstream GTG module exists";
      }
    ];
  };
}
