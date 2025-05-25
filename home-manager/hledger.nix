{ pkgs, lib, config, ... }:

let
  cfg = config.programs.hledger;
in

{
  options.programs.hledger = {
    enable = lib.mkEnableOption "Enable hledger";

    hledgerPath = lib.mkOption {
      description = "Path to hledger files";
      default = config.xdg.dataHome + "/hledger";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hledger ];

    home.sessionVariables.LEDGER_FILE = cfg.hledgerPath + "/ledgers/2025/main.journal";

    home.shellAliases = {
      hl = "hledger";
      hlo = "cd ${cfg.hledgerPath} && e $LEDGER_FILE";
    };

    services.git-sync.repositories.hledger = {
      path = cfg.hledgerPath;
      uri = "git@github.com:avrahamappel/pta.git";
    };

    programs.neovim.plugins = [ pkgs.vimPlugins.vim-ledger ];
  };
}
