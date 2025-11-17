{ stdenv
, apple-sdk
, replaceVars
, rcodesign
, zig
}:

let
  srcs = import ../../../npins;

  src = srcs."skhd.zig";
in

stdenv.mkDerivation {
  pname = "skhd.zig";

  inherit (src) version;
  inherit src;

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = [ rcodesign ];

  patches = [
    (replaceVars ./add-framework-paths.patch {
      darwin-frameworks = "${apple-sdk.sdkroot}/System/Library/Frameworks";
    })
  ];

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];

  postBuild = ''
    echo "Signing binary with rcodesign..."
    rcodesign sign --verbose --code-signature-flags runtime ./zig-out/bin/skhd
  '';
}
