{ pkgs, inputs, ... }:

# QR utilities

let
  qrscan = inputs.qrscan.packages.${pkgs.stdenv.hostPlatform.system}.qrscan;
in

{
  home.packages = with pkgs; [
    qrtool # Decode QR codes, even from image files
    qrscan # Scan QR codes from command line using system camera
  ];

  home.shellAliases = {
    qr = "qrscan";
    qrc = "qrscan | ${if pkgs.stdenv.isDarwin then "pbcopy" else "wl-copy"}";
    qrd = "qrscan | tee /dev/tty | xargs ddgr -x --np";
    qro = "qrscan | xargs ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"}";
    qrv = "qrscan >> ~/Downloads/contacts.vcf";
    qw = "qrtool encode -t terminal";
  };
}
