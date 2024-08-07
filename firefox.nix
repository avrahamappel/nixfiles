{ pkgs, ... }:

let
  nur = pkgs.callPackage (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in

{
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;

    profiles.default = {
      extensions = with nur.repos.rycee.firefox-addons; [
        adblocker-ultimate
        automatic-dark
        browserpass
        copy-link-text
        duckduckgo-privacy-essentials
        enhanced-github
      ];

      search.default = "DuckDuckGo";
      search.force = true; # Rebuilding fails without this

      settings = {
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "signon.rememberSignons" = false;
      };
    };
  };
}
