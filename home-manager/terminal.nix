{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics; # Supports sixel etc.
    settings = {
      window = {
        opacity = 0.9;
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

      env.term = "xterm-256color";
    };
  };

  programs.tmux = {
    enable = true;
    shortcut = "z";
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    extraConfig = ''
      set-option -g status off
      set-option -g set-titles on
      set-option -g set-titles-string '#{session_name} (tmux)'

      # True color settings
      set -g default-terminal "$TERM"
      set -ag terminal-overrides ",$TERM:Tc"

      # Undercurl settings
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    '';
  };
}
