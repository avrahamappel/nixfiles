{ stdenv
, apple-sdk
, replaceVars
, zig_0_14
}:

let
  srcs = import ../../../npins;

  src = srcs."skhd.zig";

  zig = zig_0_14;
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
