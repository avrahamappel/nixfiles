{ lib
, curl
, html-tidy
, libGL
, libnotify
, mailspring
, openssl
, patchelf
}:

let
  # Not npinning as the nixpkgs version downloads the prebuilt package
  # and I don't want to roll my own build
  version = "1.17.4";
  hash = "sha256-PHxe44yzX9Zz+fQu30kX9epLEeG3wqqVL3p5+ZHMmos=";
in

mailspring.overrideAttrs (prev: {
  inherit version;

  src = prev.src.overrideAttrs { inherit hash; };

  buildInputs = prev.buildInputs ++ [
    curl
    openssl
  ];

  runtimeDependencies = prev.runtimeDependencies ++ [
    curl
    libGL
    libnotify
    html-tidy
  ];

  postFixup = prev.postFixup + # sh 
    ''
      ${lib.getExe patchelf} --add-needed libEGL.so.1 \
        $out/share/mailspring/libEGL.so
    '';
})
