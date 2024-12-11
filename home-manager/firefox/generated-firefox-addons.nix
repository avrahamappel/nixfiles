{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
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