{ lib, config, ... }:

{
  options.firefoxProfileDefaults = lib.mkOption {
    description = "Defaults for Firefox profiles, extracted to allow merging";
    default = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
        adblocker-ultimate
        browserpass
        copy-link-text
        duckduckgo-privacy-essentials
        surfingkeys
      ];

      search.default = "DuckDuckGo";
      search.force = true; # Rebuilding fails without this

      settings = {
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.weather.temperatureUnits" = "c";
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
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
