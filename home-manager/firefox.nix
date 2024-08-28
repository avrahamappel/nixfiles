{ lib, config, ... }:

{
  options.firefoxProfileDefaults = lib.mkOption {
    description = "Defaults for Firefox profiles, extracted to allow merging";
    default = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
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

  config = {
    programs.firefox = {
      enable = true;
      profiles.default = config.firefoxProfileDefaults;
    };
  };
}
