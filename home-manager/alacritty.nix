{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.75;
        decorations = "None";
        startup_mode = "Maximized";
      };
      font = {
        normal.family = "UbuntuMono Nerd Font";
        size = 12.5;
      };
      cursor.vi_mode_style.blinking = "On";
      keyboard.bindings = (pkgs.lib.optional pkgs.stdenv.isLinux {
        key = "N";
        mods = "Shift|Control";
        action = "CreateNewWindow";
      });
    };
  };
}

