{ lib
, html-tidy
, libnotify
, mailspring
, patchelf
}:

let
  # Not npinning as the nixpkgs version downloads the prebuilt package
  # and I don't want to roll my own build
  version = "1.23.0";
  # NOTE: this is the hash for x86_64-linux. You can get it by visiting
  # the release in Github, clicking the copy icon next to the amd64.deb
  # asset, and running:
  # wl-paste | sed 's/sha256://' | xxd -r -p | base64 | read hash && echo "sha256-$hash" | tee /dev/tty | wl-copy
  hash = "sha256-9vYpN1IwBXsbYSOlxVsA4fftYGsEB5purqddaBkz5ck=";

  assertions = [
    {
      assertion = !lib.versionOlder version mailspring.version;
      message = "Upstream Mailspring version is newer";
    }
    {
      assertion = builtins.match "libEGL" mailspring.postFixup == null;
      message = "https://github.com/NixOS/nixpkgs/pull/282748 has been merged, need to rework my fix";
    }
  ];

  warnings = lib.optional
    (builtins.any (p: lib.getName p == "libnotify")
      mailspring.runtimeDependencies)
    "`libnotify` has already been added to Mailspring's runtime dependencies"
  ++ lib.optional
    (builtins.any (p: lib.getName p == "html-tidy")
      mailspring.runtimeDependencies)
    "`libtidy`/`html-tidy` has already been added to Mailspring's runtime dependencies";

  package = mailspring.overrideAttrs (prev: {
    inherit version;

    src = prev.src.overrideAttrs { inherit hash; };

    runtimeDependencies = prev.runtimeDependencies ++ [
      libnotify
      html-tidy
    ];

    postFixup = prev.postFixup + # sh 
      ''
        ${lib.getExe patchelf} --add-needed libEGL.so.1 \
          $out/share/mailspring/libEGL.so
      '';

    meta.platforms = [ "x86_64-linux" ];
  });
in

lib.asserts.checkAssertWarn assertions warnings package
