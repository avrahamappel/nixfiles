{ pkgs, lib, config, rycee-nur, inputs, ... }:

let
  local-addons = pkgs.callPackage ./generated-firefox-addons.nix {
    buildMozillaXpiAddon = rycee-nur.firefox-addons.buildFirefoxXpiAddon;
  };

  bus-extension = inputs.bus-extension.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
        ]
        ++ lib.optional config.bus-extension.enable bus-extension;

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
      } // lib.optionalAttrs config.bus-extension.enable {
        ${bus-extension.addonId}.permissions = [
          "activeTab"
          "storage"
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
  options.bus-extension.enable = lib.mkEnableOption "Enable bus-extension in firefox (developer edition required)";

  config.programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.dev-edition-default = profile;
  };
}
