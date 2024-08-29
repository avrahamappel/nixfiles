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

  programs.tmux = {
    enable = true;
    shortcut = "z";
    terminal = "xterm-256color";
    keyMode = "vi";
    mouse = true;
    extraConfig = ''
      set-option -g status off
      set-option -g set-titles on
      set-option -g set-titles-string '#{session_name} (tmux)'
    '';
  };
}
