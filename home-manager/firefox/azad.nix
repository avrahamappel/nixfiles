{ buildNpmPackage
, importNpmLock
, zip
, jq
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

  nativeBuildInputs = [ zip jq ];

  postPatch = ''
    echo 'Tweaking build scripts'

    # Override git hash stuff
    sed -i 's/HASH=\$(git rev-parse HEAD)/HASH=${src.revision}/' utils/updateGitHashFile.sh
    sed -i 's/DIRT=\$(git status --porcelain=v2)/DIRT=/' utils/updateGitHashFile.sh

    # Specify path to tsc for linting
    sed -i 's|lint": "tsc|lint": "node_modules/typescript/bin/tsc|' package.json
  '';

  # npmInstallFlags = [ "--include=dev" ];
  # npmBuildScript = "package";

  # buildPhase = ''
  #   # Copy source into build dir
  #   cd $src/src || exit 1
  #
  #   # Ensure we have a manifest.json
  #   if [ ! -f manifest.json ]; then
  #     echo "manifest.json not found"
  #     exit 1
  #   fi
  #
  #   # Read version from manifest.json if present
  #   jq -r '.version // empty' manifest.json > .manifest-version || true
  #   ver=$(cat .manifest-version || echo "${version}")
  #
  #   # Create the xpi (zip of all files at repo root)
  #   mkdir -p build
  #   (cd $src/src; zip -r ../build/${pname}-${version}.xpi . -x '.*' ) >/dev/null
  # '';

  # postBuild = ''
  #   mkdir -p $out
  #   cp azad.zip $out/azad.xpi
  # '';
}
