{ pkgs, lib, config, rycee-nur, ... }:

let
  local-addons = pkgs.callPackage ./generated-firefox-addons.nix {
    inherit (rycee-nur.firefox-addons) buildFirefoxXpiAddon;
  };

  bus-extension = pkgs.callPackage (import ../../npins).bus-extension { };
in

{
  options.firefoxProfileDefaults = lib.mkOption {
    description = "Defaults for Firefox profiles, extracted to allow merging";
    default = {
      extensions = with rycee-nur.firefox-addons; {
        packages = [
          adblocker-ultimate
          browserpass
          duckduckgo-privacy-essentials
          surfingkeys
          qr-code-address-bar
        ] ++ (with local-addons; [
          amazon-orders-to-beancount
          cors-everywhere
          # For downloading stuff from archive.org.
          # Requires disabling CORS to use,
          # hence the previous addon
          internet_archive_downloader
        ]) ++ [ bus-extension ];

        exhaustivePermissions = true;
        exactPermissions = true;
        force = true;

        settings = {
          ${adblocker-ultimate.addonId}.permissions = [
            "<all_urls>"
            "contextMenus"
            "http://*/*"
            "https://*/*"
            "storage"
            "tabs"
            "unlimitedStorage"
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
          ${local-addons.amazon-orders-to-beancount.addonId}.permissions = [
            "*://*.amazon.ca/gp/*/order-history?*"
            "*://amazon.ca/gp/*/order-history?*"
            "*://*.amazon.ca/your-orders/orders?*"
            "*://amazon.ca/your-orders/orders?*"
            "*://*.amazon.com/gp/*/order-history?*"
            "*://amazon.com/gp/*/order-history?*"
            "*://*.amazon.com/your-orders/orders?*"
            "*://amazon.com/your-orders/orders?*"
            "storage"
            "webRequest"
          ];
          ${local-addons.cors-everywhere.addonId}.permissions = [
            "<all_urls>"
            "storage"
            "webRequest"
            "webRequestBlocking"
          ];
          ${local-addons.internet_archive_downloader.addonId}.permissions = [
            "declarativeNetRequest"
            "downloads"
            "notifications"
            "scripting"
            "storage"
            "tabs"
          ];
          ${bus-extension.addonId}.permissions = [ "activeTab" ];
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
  };

  config = {
    programs.firefox = {
      enable = true;
      profiles.default = config.firefoxProfileDefaults;
    };
  };
}
