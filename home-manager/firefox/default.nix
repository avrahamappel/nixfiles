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
      extensions.packages = with rycee-nur.firefox-addons; [
        adblocker-ultimate
        browserpass
        duckduckgo-privacy-essentials
        surfingkeys
        qr-code-address-bar
      ] ++ (with local-addons; [
        amazon-orders-to-beancount
        cors-everywhere
        # For downloading stuff from archive.org.
        # Requires dsabling CORS to use, hence 
        # the previous addon
        internet_archive_downloader
      ]);

      search.default = "ddg";
      search.force = true; # Rebuilding fails without this

      settings = {
        "accessibility.typeaheadfind.enablesound" = false; # Don't make noise when nothing is found
        "browser.altClickSave" = true; # Alt+Click to save link
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.weather.temperatureUnits" = "c";
        "browser.sessionstore.enabled" = true;
        "browser.sessionstore.resume_session_once" = true;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
        "media.webspeech.recognition.enable" = true; # Enable Web Speech API
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
