{ lib
, stdenv
, formats
}:

let
  jsonFormatter = formats.json { };

  src = (import ../../npins).Walmart-Invoice-Exporter;

  addonId = "walmart-invoice-exporter@hppanpaliya.github.io";

  origManifest = builtins.fromJSON (builtins.readFile "${src}/manifest.json");

  newManifest = lib.removeAttrs
    (origManifest // {
      browser_specific_settings.gecko.id = addonId;
      background.scripts = [ origManifest.background.service_worker ];
      permissions = lib.remove "sidePanel" origManifest.permissions;
      sidebar_action.default_panel = origManifest.side_panel.default_path;
    }) [ "side_panel" ];

  manifestFile = jsonFormatter.generate "manifest.json" newManifest;

  version = "${origManifest.version}-${builtins.substring 0 7 src.revision}";
in

stdenv.mkDerivation {
  pname = "walmart-invoice-exporter";

  inherit version src;

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = {
    inherit addonId;
  };

  buildCommand = # bash
    ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst/${addonId}"

      # Install files recursively
      for file in $(find $src -type f); do
        install -v -D -m644 "$file" "$dst/${addonId}/''${file#$src}"
      done

      # Patch the manifest with the Firefox addon ID
      cp -f ${manifestFile} $dst/${addonId}/manifest.json
    '';

  meta.mozPermissions = newManifest.permissions ++ newManifest.host_permissions;
}
