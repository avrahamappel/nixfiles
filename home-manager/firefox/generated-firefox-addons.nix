{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "amazon-orders-to-beancount" = buildFirefoxXpiAddon {
      pname = "amazon-orders-to-beancount";
      version = "1.0";
      addonId = "amazon-bean@darksair.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4282369/amazon_orders_to_beancount-1.0.xpi";
      sha256 = "f3078ee3f7ca65720db2ebeae087c32b6ad6a49f231e099b926bd73dfbdaaf3b";
      meta = with lib;
      {
        homepage = "https://github.com/MetroWind/amazon-beancount-firefox";
        description = "Scrap order info from Amazon, and generate Beancount entries.";
        mozPermissions = [
          "storage"
          "webRequest"
          "*://*.amazon.com/gp/*/order-history?*"
          "*://amazon.com/gp/*/order-history?*"
          "*://*.amazon.com/your-orders/orders?*"
          "*://amazon.com/your-orders/orders?*"
          "*://*.amazon.ca/gp/*/order-history?*"
          "*://amazon.ca/gp/*/order-history?*"
          "*://*.amazon.ca/your-orders/orders?*"
          "*://amazon.ca/your-orders/orders?*"
        ];
        platforms = platforms.all;
      };
    };
    "cors-everywhere" = buildFirefoxXpiAddon {
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
    "internet_archive_downloader" = buildFirefoxXpiAddon {
      pname = "internet_archive_downloader";
      version = "1.0.2";
      addonId = "internet_archive_downloader@timelegend.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4400863/internet_archive_downloader-1.0.2.xpi";
      sha256 = "5460356c8f2d1bed9fcfbc06bdfc8841197933e3e4bedae9d5f45672c6fde46f";
      meta = with lib;
      {
        homepage = "https://github.com/elementdavv/internet_archive_downloader";
        description = "Download PDF books from Internet Archive";
        license = licenses.gpl3;
        mozPermissions = [
          "declarativeNetRequest"
          "downloads"
          "scripting"
          "storage"
          "tabs"
        ];
        platforms = platforms.all;
      };
    };
  }