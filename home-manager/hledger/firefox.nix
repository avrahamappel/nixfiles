{ pkgs, lib, config, rycee-nur, ... }:

# Firefox extensions for exporting transaction data

let
  local-addons = pkgs.callPackage ../firefox/generated-firefox-addons.nix {
    buildMozillaXpiAddon = rycee-nur.firefox-addons.buildFirefoxXpiAddon;
  };

  inherit (local-addons) order-history-exporter-amazon;

  walmart-invoice-exporter = pkgs.callPackage ./walmart-invoice-exporter.nix { };
in

{
  config = lib.mkIf config.hledger.enable {
    programs.firefox.profiles.dev-edition-default.extensions = {
      packages = [
        order-history-exporter-amazon
        walmart-invoice-exporter
      ];
      settings = {
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
        ${walmart-invoice-exporter.addonId}.permissions = [
          "activeTab"
          "storage"
          "https://www.walmart.com/*"
        ];
      };
    };
  };
}
