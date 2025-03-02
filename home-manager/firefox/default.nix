{ pkgs, lib, config, rycee-nur, ... }:

let
  local-addons = pkgs.callPackage ./generated-firefox-addons.nix {
    inherit (rycee-nur.firefox-addons) buildFirefoxXpiAddon;
  };
in

{
  options.firefoxProfileDefaults = lib.mkOption {
    description = "Defaults for Firefox profiles, extracted to allow merging";
    default = {
      extensions = with rycee-nur.firefox-addons; [
        adblocker-ultimate
        browserpass
        duckduckgo-privacy-essentials
        surfingkeys
        qr-code-address-bar
      ] ++ (with local-addons; [
        cors-everywhere
        internet_archive_downloader # For downloading stuff from archive.org.
                                    # Requires dsabling CORS to use, hence 
                                    # the previous addon is necessary
      ]);

      search.default = "DuckDuckGo";
      search.force = true; # Rebuilding fails without this

      settings = {
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.weather.temperatureUnits" = "c";
        "browser.sessionstore.enabled" = true;
        "browser.sessionstore.resume_session_once" = true;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
        "signon.rememberSignons" = false;
      };
    };
  };

  config = {
    home.packages = [ rycee-nur.mozilla-addons-to-nix ];

    programs.firefox = {
      enable = true;
      profiles.default = config.firefoxProfileDefaults;
    };
  };
}
