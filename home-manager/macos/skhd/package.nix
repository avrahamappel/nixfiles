{ stdenv
, darwin
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
    darwin.autoSignDarwinBinariesHook
  ];

  patches = [
    (replaceVars ./patches/add-framework-paths.patch {
      darwinFrameworks = "${apple-sdk.sdkroot}/System/Library/Frameworks";
    })
    (replaceVars ./patches/use-git-hash-from-nix.patch {
      gitHash = builtins.substring 0 7 src.revision;
    })
  ];

  zigBuildFlags = [ "-Doptimize=ReleaseFast" ];
}
