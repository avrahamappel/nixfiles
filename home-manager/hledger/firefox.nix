{ pkgs, lib, config, rycee-nur, ... }:

# Firefox extensions for exporting transaction data

let
  local-addons = pkgs.callPackage ../firefox/generated-firefox-addons.nix {
    buildMozillaXpiAddon = rycee-nur.firefox-addons.buildFirefoxXpiAddon;
  };

  inherit (local-addons) order-history-exporter-amazon;
in

{
  config = lib.mkIf config.hledger.enable {
    programs.firefox.profiles.dev-edition-default.extensions = {
      packages = [
        order-history-exporter-amazon
      ];
      settings = {
        ${order-history-exporter-amazon.addonId}.permissions = [
          "activeTab"
          "*://*.amazon.ae/*"
          "*://*.amazon.ae/*gp/css/order-history*"
          "*://*.amazon.ae/*gp/your-account/order-history*"
          "*://*.amazon.ae/*your-orders*"
          "*://*.amazon.ca/*"
          "*://*.amazon.ca/*gp/css/order-history*"
          "*://*.amazon.ca/*gp/your-account/order-history*"
          "*://*.amazon.ca/*your-orders*"
          "*://*.amazon.co.jp/*"
          "*://*.amazon.co.jp/*gp/css/order-history*"
          "*://*.amazon.co.jp/*gp/your-account/order-history*"
          "*://*.amazon.co.jp/*your-orders*"
          "*://*.amazon.com/*"
          "*://*.amazon.com.au/*"
          "*://*.amazon.com.au/*gp/css/order-history*"
          "*://*.amazon.com.au/*gp/your-account/order-history*"
          "*://*.amazon.com.au/*your-orders*"
          "*://*.amazon.com.be/*"
          "*://*.amazon.com.be/*gp/css/order-history*"
          "*://*.amazon.com.be/*gp/your-account/order-history*"
          "*://*.amazon.com.be/*your-orders*"
          "*://*.amazon.com.br/*"
          "*://*.amazon.com.br/*gp/css/order-history*"
          "*://*.amazon.com.br/*gp/your-account/order-history*"
          "*://*.amazon.com.br/*your-orders*"
          "*://*.amazon.com/*gp/css/order-history*"
          "*://*.amazon.com/*gp/your-account/order-history*"
          "*://*.amazon.com.mx/*"
          "*://*.amazon.com.mx/*gp/css/order-history*"
          "*://*.amazon.com.mx/*gp/your-account/order-history*"
          "*://*.amazon.com.mx/*your-orders*"
          "*://*.amazon.com/*your-orders*"
          "*://*.amazon.co.uk/*"
          "*://*.amazon.co.uk/*gp/css/order-history*"
          "*://*.amazon.co.uk/*gp/your-account/order-history*"
          "*://*.amazon.co.uk/*your-orders*"
          "*://*.amazon.de/*"
          "*://*.amazon.de/*gp/css/order-history*"
          "*://*.amazon.de/*gp/your-account/order-history*"
          "*://*.amazon.de/*your-orders*"
          "*://*.amazon.es/*"
          "*://*.amazon.es/*gp/css/order-history*"
          "*://*.amazon.es/*gp/your-account/order-history*"
          "*://*.amazon.es/*your-orders*"
          "*://*.amazon.fr/*"
          "*://*.amazon.fr/*gp/css/order-history*"
          "*://*.amazon.fr/*gp/your-account/order-history*"
          "*://*.amazon.fr/*your-orders*"
          "*://*.amazon.in/*"
          "*://*.amazon.in/*gp/css/order-history*"
          "*://*.amazon.in/*gp/your-account/order-history*"
          "*://*.amazon.in/*your-orders*"
          "*://*.amazon.it/*"
          "*://*.amazon.it/*gp/css/order-history*"
          "*://*.amazon.it/*gp/your-account/order-history*"
          "*://*.amazon.it/*your-orders*"
          "*://*.amazon.se/*"
          "*://*.amazon.se/*gp/css/order-history*"
          "*://*.amazon.se/*gp/your-account/order-history*"
          "*://*.amazon.se/*your-orders*"
          "downloads"
          "storage"
        ];
      };
    };
  };
}
