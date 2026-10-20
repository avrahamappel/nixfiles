{ pkgs, ... }:

let
  circuitTheme = pkgs.adi1090x-plymouth-themes.override {
    selected_themes = [ "circuit" ];
  };

  circuitThemeWithToshuns = circuitTheme.overrideAttrs {
    patchPhase = ''
      cat << 'EOF' >> circuit/circuit.script
      # Add more toshuns
      fun refresh_callback2() {
          # Call original callback
          refresh_callback();

          if (Plymouth.GetMode() == "boot") {
              text = "These toshuns are turning on...";
          } else if (Plymouth.GetMode() == "shutdown") {
              text = "These toshuns are turning off...";
          } else if (Plymouth.GetMode() == "suspend") {
              text = "These toshuns are going to sleep...";
          } else if (Plymouth.GetMode() == "resume") {
              text = "These toshuns are waking up...";
          } else if (Plymouth.GetMode() == "reboot") {
              text = "These toshuns are restarting...";
          } else {
              text = "Toshun status: " + Plymouth.GetMode();
          }
          message.image = Image.Text(text, 0, 0.8, 1);
          message.sprite = Sprite(message.image);
          message.sprite.SetPosition(screen.half.w - message.image.GetWidth() / 2, Window.GetHeight() - message.image.GetHeight() - 50);
      }
      # Override refresh callback
      Plymouth.SetRefreshFunction(refresh_callback2);
      EOF
    '';
  };
in

{
  boot.plymouth = {
    enable = true;
    theme = "circuit";
    themePackages = [ circuitThemeWithToshuns ];
  };
}
