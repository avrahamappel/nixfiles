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
          order-history-exporter-amazon
          sixthirteentube
        ]
        ++ lib.optional config.bus-extension.enable bus-extension;

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
        ];
        ${order-history-exporter-amazon.addonId}.permissions = [
          "activeTab"
          "downloads"
          "*://*.amazon.com/*"
          "*://*.amazon.co.uk/*"
          "*://*.amazon.de/*"
          "*://*.amazon.fr/*"
          "*://*.amazon.it/*"
          "*://*.amazon.es/*"
          "*://*.amazon.ca/*"
          "*://*.amazon.co.jp/*"
          "*://*.amazon.in/*"
          "*://*.amazon.com.au/*"
          "*://*.amazon.com.br/*"
          "*://*.amazon.com.mx/*"
          "*://*.amazon.com.be/*"
          "*://*.amazon.com/*gp/your-account/order-history*"
          "*://*.amazon.com/*gp/css/order-history*"
          "*://*.amazon.com/*your-orders*"
          "*://*.amazon.co.uk/*gp/your-account/order-history*"
          "*://*.amazon.co.uk/*gp/css/order-history*"
          "*://*.amazon.co.uk/*your-orders*"
          "*://*.amazon.de/*gp/your-account/order-history*"
          "*://*.amazon.de/*gp/css/order-history*"
          "*://*.amazon.de/*your-orders*"
          "*://*.amazon.fr/*gp/your-account/order-history*"
          "*://*.amazon.fr/*gp/css/order-history*"
          "*://*.amazon.fr/*your-orders*"
          "*://*.amazon.it/*gp/your-account/order-history*"
          "*://*.amazon.it/*gp/css/order-history*"
          "*://*.amazon.it/*your-orders*"
          "*://*.amazon.es/*gp/your-account/order-history*"
          "*://*.amazon.es/*gp/css/order-history*"
          "*://*.amazon.es/*your-orders*"
          "*://*.amazon.ca/*gp/your-account/order-history*"
          "*://*.amazon.ca/*gp/css/order-history*"
          "*://*.amazon.ca/*your-orders*"
          "*://*.amazon.co.jp/*gp/your-account/order-history*"
          "*://*.amazon.co.jp/*gp/css/order-history*"
          "*://*.amazon.co.jp/*your-orders*"
          "*://*.amazon.in/*gp/your-account/order-history*"
          "*://*.amazon.in/*gp/css/order-history*"
          "*://*.amazon.in/*your-orders*"
          "*://*.amazon.com.au/*gp/your-account/order-history*"
          "*://*.amazon.com.au/*gp/css/order-history*"
          "*://*.amazon.com.au/*your-orders*"
          "*://*.amazon.com.br/*gp/your-account/order-history*"
          "*://*.amazon.com.br/*gp/css/order-history*"
          "*://*.amazon.com.br/*your-orders*"
          "*://*.amazon.com.mx/*gp/your-account/order-history*"
          "*://*.amazon.com.mx/*gp/css/order-history*"
          "*://*.amazon.com.mx/*your-orders*"
          "*://*.amazon.com.be/*gp/your-account/order-history*"
          "*://*.amazon.com.be/*gp/css/order-history*"
          "*://*.amazon.com.be/*your-orders*"
        ];
        ${sixthirteentube.addonId}.permissions = [
          "storage"
          "webRequest"
          "webRequestBlocking"
          "*://www.youtube.com/*"
          "*://youtube.com/*"
          "*://www.youtube-nocookie.com/*"
          "*://youtube-nocookie.com/*"
          "https://613tube.com/*"
          "https://www.youtube-nocookie.com/embed/*"
          "https://youtube-nocookie.com/embed/*"
          "https://www.youtube.com/embed/*"
          "https://youtube/embed/*"
        ];
      } // lib.optionalAttrs config.bus-extension.enable {
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
in

{
  options.bus-extension.enable = lib.mkEnableOption "Enable bus-extension in firefox (developer edition required)";

  config.programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.dev-edition-default = profile;
  };
}
