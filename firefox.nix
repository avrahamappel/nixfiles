{ pkgs, lib, ... }:

let
  nur = pkgs.callPackage (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in

{
  programs.firefox = {
    enable = true;

    # Disable package installation on Mac
    package = lib.mkIf pkgs.stdenv.isDarwin null;

    profiles.default = {
      extensions = with nur.repos.rycee.firefox-addons; [
        adblocker-ultimate
        automatic-dark
        browserpass
        copy-link-text
        duckduckgo-privacy-essentials
        enhanced-github
        vimium
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
