{ lib, pkgs, config, options, ... }:

let
  cfg = config.gtg;
  gtgHome = config.xdg.dataHome + "/gtg";

  # package = pkgs.gtg.overridePythonAttrs {
  #   postPatch = ''
  #     cat <<PYTHON > GTG/__init__.py
  #     import gi
  #     gi.require_version('Gtk', '3.0')
  #     PYTHON
  #
  #     # Move imports lines down
  #     # See here for explanation
  #     # http://stackoverflow.com/questions/44920864/ddg#44928133
  #     sed -i '19{N;h;d};23G' GTG/gtk/browser/cell_renderer_tags.py
  #
  #     # Add version
  #     sed -i "23i gi.require_version('Gtk', '3.0')" \
  #       GTG/gtk/browser/cell_renderer_tags.py
  #   '';
  # };

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
        assertion = !(options.programs ? gtg);
        message = "Upstream GTG module exists";
      }
    ];
  };
}
