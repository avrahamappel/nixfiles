{ lib
, libcosmicAppHook
, rustPlatform
}:

let
  source = (import ../../../npins).cosmic-battery-applet;

  cargoToml = lib.fromTOML (builtins.readFile "${source}/Cargo.toml");
in

rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  version = "0-unstable-${builtins.substring 0 7 source.revision}";

  src = lib.cleanSourceWith {
    # Remove the `target' dir which was committed by mistake
    filter = (path: type: type != "directory" || baseNameOf path != "target");
    src = source.outPath;
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${source}/Cargo.lock";
    outputHashes = {
      "accesskit-0.22.0" = "sha256-pP9CyiV1zIONQ7vbl5MkMtilemSPrHaZ0c/SyR+lb0k=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-a+SLHG/8G5tUiQzO0NaMbMMZRPoyUz1aJ7JIebrxGHo=";
      "cosmic-client-toolkit-0.2.0" = "sha256-ymn+BUTTzyHquPn4hvuoA3y1owFj8LVrmsPu2cdkFQ8=";
      "cosmic-config-1.0.0" = "sha256-PsBzdRdn6SCEFhhbjQhsIS+Jc5ZcYfhiOimomg9lzlA=";
      "cosmic-freedesktop-icons-0.4.0" = "sha256-D4bWHQ4Dp8UGiZjc6geh2c2SGYhB7mX13THpCUie1c4=";
      "cosmic-panel-config-0.1.0" = "sha256-DCeM9dpYpqLGdVW0MNQ4N9uWo97VpV7lSBhWJ0ufCC4=";
      "cosmic-settings-daemon-0.1.0" = "sha256-YRCNF2NQia6a9QlUIoEw0v2bMiZq94eViLsx+8NoghI=";
      "cosmic-text-0.18.2" = "sha256-fBtTOzS6DHkjoDI6dtUCY0/pk5/pwxvXErKNdnrlppk=";
      "cryoglyph-0.1.0" = "sha256-sSfgXlWgrM4wdczdquqzc/uuUmHL/GuK+Xvn0XNO+UQ=";
      "dpi-0.1.2" = "sha256-sOf5RuK4fs9FspaUnnviEx2SHNB+6oImg4Ox/owUGzo=";
      "smithay-clipboard-0.8.0" = "sha256-GojAFRbhJcP0Rpr+v9WOivgW9x38PZdeBWTbMhkDB3A=";
      "softbuffer-0.4.1" = "sha256-/ocK79Lr5ywP/bb5mrcm7eTzeBbwpOazojvFUsAjMKM=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  # Copy desktop file
  postInstall = ''
    install -D $src/cosmic-battery-applet.desktop $out/share/applications/cosmic-battery-applet.desktop
  '';
}
