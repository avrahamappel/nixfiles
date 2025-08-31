{ config, ... }:

{
  options.gtd = {
    enable = config.lib.mkEnableOption "Enable GTD tracking system" // { default = true; };
  };

  config = {
    services.git-sync.repositories.gtd = {
      path = config.home.homeDirectory + "/gtd";
      uri = "git@github.com:avrahamappel/gtd.git";
    };
  };
}
