{ applyPatches
, fetchFromGitHub
, rustPlatform
, alacritty
}:

let
  src = applyPatches {
    name = "alacritty-bidi-source";
    src = (fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty";
      rev = "pull/7872/head";
      hash = "sha256-anLfjg0LvhZgb4oQU1ixAg2/zH++JQWhIndKmsCOVic=";
    });
    # This patch merges the two utf8parse-0.2.1 crates,
    # without which importCargoLock would fail
    patches = [ ./alacritty-bidi-cargo-lock.patch ];
  };
in

alacritty.overrideAttrs (final: prev: {
  version = "pr-7872";

  inherit src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = final.src + "/Cargo.lock";
    outputHashes."utf8parse-0.2.1" = "sha256-G5WkKeeoH1MLLsCmcMD/QqkO+sq9wCUWEuh2BQvyBBE=";
  };

  cargoBuildFeatures = [ "bidi_draft" ];
})
