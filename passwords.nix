{ pkgs, ... }:

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
}
