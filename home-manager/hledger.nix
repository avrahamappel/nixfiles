{ pkgs, lib, config, ... }:

{
  options = {
    hledgerPath = lib.mkOption {
      description = "Path to hledger files";
      default = config.xdg.dataHome + "/hledger";
    };
  };

  config = {
    home.packages = [ pkgs.hledger ];

    home.sessionVariables.LEDGER_FILE = config.hledgerPath + "/ledgers/2025/main.journal";

    home.shellAliases = {
      hl = "hledger";
      hlo = "cd ${config.hledgerPath} && e $LEDGER_FILE";
    };

    services.git-sync.repositories.hledger = {
      path = config.hledgerPath;
      uri = "git@github.com:avrahamappel/pta.git";
    };
  };
}
