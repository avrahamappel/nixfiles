{ pkgs, lib, config, ... }:

{
  options.passwords.enable = lib.mkEnableOption "Enable password-store manager";

  config = lib.mkIf config.passwords.enable {
    programs.gpg.enable = true;

    programs.password-store = {
      enable = true;
      settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-update
      ]);
    };

    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    services.git-sync.repositories.pass = {
      path = config.programs.password-store.settings.PASSWORD_STORE_DIR;
      uri = "git@github.com:avrahamappel/password-store.git";
    };
  };
}
