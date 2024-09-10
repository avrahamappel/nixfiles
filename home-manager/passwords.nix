{ pkgs, config, ... }:

{
  programs = {
    gpg.enable = true;

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-update
      ]);
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  services.git-sync.repositories.pass = {
    path = config.programs.password-store.settings.PASSWORD_STORE_DIR;
    uri = "git@github.com:avrahamappel/password-store.git";
  };
}
