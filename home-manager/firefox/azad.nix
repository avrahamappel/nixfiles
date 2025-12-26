{ buildNpmPackage
, importNpmLock
, zip
# , jq
}:

let
  srcs = import ../../npins;
  src = srcs.azad;
in

buildNpmPackage rec {
  pname = "firefox-azad";

  inherit src;
  inherit (src) version;

  npmDeps = importNpmLock { npmRoot = src.outPath; };
  inherit (importNpmLock) npmConfigHook;

  nativeBuildInputs = [ zip ];

  postPatch = ''
    echo 'Tweaking build scripts'

    patchShebangs utils

    # Override git hash stuff
    sed -i 's/HASH=\$(git rev-parse HEAD)/HASH=${src.revision}/' utils/updateGitHashFile.sh
    sed -i 's/DIRT=\$(git status --porcelain=v2)/DIRT=/' utils/package.sh utils/updateGitHashFile.sh

    # Specify path to tsc for linting
    sed -i 's|lint": "tsc|lint": "node_modules/typescript/bin/tsc|' package.json
  '';

  npmBuildScript = "package";

  postBuild = ''
    mkdir -p $out
    echo "Creating XPI archive"
    cp azad.zip $out/azad.xpi
  '';
}
