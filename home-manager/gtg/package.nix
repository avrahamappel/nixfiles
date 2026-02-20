{ lib
, gtg
, gtk3
, gtk4
, gtksourceview4
, gtksourceview5
, libportal
, pkg-config
, wrapGAppsHook3
, wrapGAppsHook4
}:

let
  src = (import ../../npins).gtg;

  version =
    lib.replaceStrings [ "'" "," ] [ "" "" ]
      (lib.elemAt
        (lib.splitString " "
          (lib.elemAt
            (lib.splitString "\n" (builtins.readFile "${src}/meson.build")
            ) 1)
        ) 3
      )
  ;
in

gtg.overrideAttrs
  ({ nativeBuildInputs
   , buildInputs
   , ...
   }: {
    inherit src version;

    patches = [ ];

    nativeBuildInputs = lib.remove [
      wrapGAppsHook3
    ]
      nativeBuildInputs ++ [
      pkg-config
      wrapGAppsHook4
    ];

    buildInputs = lib.remove [
      gtk3
      gtksourceview4
    ]
      buildInputs
    ++ [
      gtk4
      gtksourceview5
      libportal
    ];

  })
