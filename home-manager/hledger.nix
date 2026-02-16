{ pkgs, lib, config, options, ... }:

let
  cfg = config.hledger;

  hledgerPath = config.xdg.dataHome + "/hledger";

  settingsPath = "hledger/hledger.conf";
  fullSettingsPath = "${config.xdg.configHome}/${settingsPath}";
in

{
  options.hledger = with lib.types; {
    enable = lib.mkEnableOption "Enable hledger";

    settings = lib.mkOption {
      type = lines;
      description = "Content of hledger.conf file";
    };
  };

  config = lib.mkIf cfg.enable {
    hledger.settings = ''
      --pretty
      --tree
    '';

    home.packages = [ pkgs.hledger ];

    home.sessionVariables = {
      HLEDGER_PATH = hledgerPath;
      LEDGER_FILE = hledgerPath + "/ledgers/$(${pkgs.coreutils}/bin/date +%Y)/main.journal";
    };

    xdg.configFile.${settingsPath}.text = cfg.settings;

    home.shellAliases = {
      hl = "hledger --conf ${fullSettingsPath}";
      hlo = "cd ${hledgerPath} && e $LEDGER_FILE";
      hlb = "hl bal --budget -V --invert 'expenses|income'";
      hl24 = "hl -f ${hledgerPath}/ledgers/2024/main.journal";
      hl25 = "hl -f ${hledgerPath}/ledgers/2025/main.journal";
    };

    services.git-sync.enable = true;
    services.git-sync.repositories.hledger = {
      path = hledgerPath;
      uri = "git@github.com:avrahamappel/pta.git";
    };

    programs.neovim.plugins = [ pkgs.vimPlugins.vim-ledger ];

    assertions = [
      {
        assertion = !(options.programs ? hledger) && !(options.services ? hledger);
        message = "Upstream hledger module exists";
      }
    ];
  };
}
