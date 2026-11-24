{ cosmicLib, ... }:

let
  inherit (cosmicLib.cosmic) mkRON;

  backgroundImg = ./backgrounds/rebbe-learning/rebbe-learning-771x1024.jpeg;
in

{
  wayland.desktopManager.cosmic.wallpapers = [
    {
      scaling_mode = mkRON "enum" {
        variant = "Fit";
        value = mkRON "tuple" [ 0 0 0 ];
      };
      source = mkRON "enum" {
        variant = "Path";
        value = backgroundImg;
      };
    }
  ];
}
