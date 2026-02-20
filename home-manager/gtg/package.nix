{ lib
, gtg
, gtk3
, gtk4
, gtksourceview4
, gtksourceview5
, libportal
, pkg-config
, python3
, python3Packages
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

gtg.overridePythonAttrs
  ({ nativeBuildInputs
   , buildInputs
   , propagatedBuildInputs
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

    propagatedBuildInputs = (with python3Packages; lib.remove [
      gst-python
      liblarch
    ]
      propagatedBuildInputs
    ++ [
      cheetah3
      dbus-python
      typing-extensions
    ]);

    checkPhase = ''
      export PYTHONPATH="$PYTHONPATH:$out/lib/${python3.libPrefix}/site-packages"
      xvfb-run pytest ../tests
    '';
  })
