{ cosmicLib, ... }:

let inherit (cosmicLib.cosmic) mkRON;
in

{
  wayland.desktopManager.cosmic.compositor = {
    autotile = true;
    autotile_behavior = mkRON "enum" "PerWorkspace";
    input_default = mkRON "raw" /* ron */ ''
      (
          state: Enabled,
          scroll_config: Some((
              natural_scroll: Some(true),
          )),
          tap_config: Some((
              enabled: false,
          )),
      )
    '';
  };
}
