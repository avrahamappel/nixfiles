{ buildMozillaXpiAddon, fetchurl, lib, stdenv }:
  {
    "cors-everywhere" = buildMozillaXpiAddon {
      pname = "cors-everywhere";
      version = "18.11.13.2044resigned1";
      addonId = "cors-everywhere@spenibus";
      url = "https://addons.mozilla.org/firefox/downloads/file/4270788/cors_everywhere-18.11.13.2044resigned1.xpi";
      sha256 = "57cfe1ab28a483751d33311d8093badcf261b81c94c5f2aecce3d8e599053c69";
      meta = with lib;
      {
        homepage = "http://spenibus.net";
        description = "A firefox addon allowing the user to enable CORS everywhere by altering http responses.\n\nReport issues to the repository, with enough information to reproduce the problem: \nhttps://github.com/spenibus/cors-everywhere-firefox-addon/issues";
        license = licenses.mit;
        mozPermissions = [
          "webRequest"
          "webRequestBlocking"
          "storage"
          "<all_urls>"
        ];
        platforms = platforms.all;
      };
    };
    "feeder" = buildMozillaXpiAddon {
      pname = "feeder";
      version = "7.7.3";
      addonId = "{73239762-0d26-4b2e-82a5-49bfd13457f0}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3577754/feeder-7.7.3.xpi";
      sha256 = "076b0e9df62d463d7a43c532b3d4bbb95ac4a2becaa987b26858462241f76ce7";
      meta = with lib;
      {
        homepage = "https://feeder.co/";
        description = "Get a simple overview of your RSS and Atom feeds in the toolbar.";
        mozPermissions = [
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
        platforms = platforms.all;
      };
    };
    "internet_archive_downloader" = buildMozillaXpiAddon {
      pname = "internet_archive_downloader";
      version = "1.1.0";
      addonId = "internet_archive_downloader@timelegend.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4511297/internet_archive_downloader-1.1.0.xpi";
      sha256 = "960aaeedc3b5163649efc3acf1c7d696b0db89fcb94ec164675af0611cf4c5be";
      meta = with lib;
      {
        homepage = "https://github.com/elementdavv/internet_archive_downloader";
        description = "Download PDF books from Internet Archive";
        license = licenses.gpl3;
        mozPermissions = [
          "declarativeNetRequest"
          "downloads"
          "notifications"
          "scripting"
          "storage"
          "tabs"
        ];
        platforms = platforms.all;
      };
    };
    "order-history-exporter-amazon" = buildMozillaXpiAddon {
      pname = "order-history-exporter-amazon";
      version = "1.2.0";
      addonId = "order-history-exporter@amazon.example";
      url = "https://addons.mozilla.org/firefox/downloads/file/4701602/order_history_exporter_amazon-1.2.0.xpi";
      sha256 = "68167c14e55c43df368e6f8bde71f2727855569afb429c8bfad8bbc930c9d8e7";
      meta = with lib;
      {
        homepage = "https://github.com/xenolphthalein/order-history-exporter-for-amazon";
        description = "Export your Amazon order history to JSON or CSV. Filter by date range, download locally. 100% private. No data collection, all processing happens on your device.";
        mozPermissions = [
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
        platforms = platforms.all;
      };
    };
  }