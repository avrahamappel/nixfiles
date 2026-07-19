{ pkgs, pkgs-unstable, rycee-nur, ... }:

let
  local-addons = pkgs.callPackage ./generated-firefox-addons.nix {
    buildMozillaXpiAddon = rycee-nur.firefox-addons.buildFirefoxXpiAddon;
  };

  profile = {
    extensions = with rycee-nur.firefox-addons; with local-addons; {
      packages =
        # rycee
        [
          adblocker-ultimate
          browserpass
          duckduckgo-privacy-essentials
          qr-code-address-bar
          surfingkeys
        ]
        # local
        ++ [
          cors-everywhere
          # For downloading stuff from archive.org.
          # Requires disabling CORS to use,
          # hence the previous addon
          internet_archive_downloader
          feeder
        ];

      exhaustivePermissions = true;
      exactPermissions = true;
      force = true;

      settings = {
        ${adblocker-ultimate.addonId}.permissions = [
          "<all_urls>"
          "contextMenus"
          "cookies"
          "http://*/*"
          "https://*/*"
          "storage"
          "tabs"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
        ];
        ${browserpass.addonId}.permissions = [
          "<all_urls>"
          "activeTab"
          "alarms"
          "clipboardRead"
          "clipboardWrite"
          "nativeMessaging"
          "notifications"
          "scripting"
          "storage"
          "tabs"
          "webRequest"
          "webRequestAuthProvider"
        ];
        ${duckduckgo-privacy-essentials.addonId}.permissions = [
          "*://*/*"
          "activeTab"
          "alarms"
          "<all_urls>"
          "contextMenus"
          "storage"
          "tabs"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
        ];
        ${surfingkeys.addonId}.permissions = [
          "<all_urls>"
          "bookmarks"
          "clipboardRead"
          "clipboardWrite"
          "contextualIdentities"
          "cookies"
          "downloads"
          "history"
          "nativeMessaging"
          "scripting"
          "sessions"
          "storage"
          "tabs"
          "topSites"
        ];
        ${qr-code-address-bar.addonId}.permissions = [ "activeTab" "menus" ];
        ${cors-everywhere.addonId}.permissions = [
          "<all_urls>"
          "storage"
          "webRequest"
          "webRequestBlocking"
        ];
        ${internet_archive_downloader.addonId}.permissions = [
          "declarativeNetRequest"
          "downloads"
          "notifications"
          "scripting"
          "storage"
          "tabs"
          "unlimitedStorage"
        ];
        ${feeder.addonId}.permissions = [
          "tabs"
          "http://*/*"
          "https://*/*"
          "chrome://favicon/"
          "storage"
          "notifications"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "unlimitedStorage"
          "http://feeder.co/*"
          "http://*.feeder.co/*"
          "https://feeder.co/*"
          "https://*.feeder.co/*"
        ];
      };
    };

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
      "extensions.autoDisableScopes" = 0; # Automatically enable extensions
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.update.autoUpdateDefault" = false;
      "media.webspeech.recognition.enable" = true; # Enable Web Speech API
      "signon.rememberSignons" = false;
      "xpinstall.signatures.required" = false; # Allow unsigned addons
    };
  };
in

{
  config.programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox-devedition;
    profiles.dev-edition-default = profile;
  };
}
