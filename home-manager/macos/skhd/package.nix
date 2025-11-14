{ stdenv
, apple-sdk
, replaceVars
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

  patches = [
    (replaceVars ./add-framework-paths.patch {
      darwin-frameworks = "${apple-sdk.sdkroot}/System/Library/Frameworks";
    })
  ];

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];
}
