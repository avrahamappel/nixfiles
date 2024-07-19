{ pkgs, ... }:

let
  nur = pkgs.callPackage (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in

{
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;

    profiles.avraham = {
      extensions = with nur.repos.rycee.firefox-addons; [
        adblocker-ultimate
        automatic-dark
        browserpass
        consent-o-matic
        copy-link-text
        duckduckgo-privacy-essentials
        enhanced-github
      ];
      # Enable addons automatically
      settings.extensions.autoDisableScopes = 0;

      search.default = "DuckDuckGo";
    };
  };
}
