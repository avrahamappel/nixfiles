{ pkgs, lib, config, ... }:

let
  cfg = config.copilot;

in

{
  options.copilot.enable = lib.mkEnableOption "Enable Github Copilot in Neovim";

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = copilot-lua;
        type = "lua";
        config = /* lua */ ''
          require('copilot').setup {
            suggestion = { enabled = false },
            panel = { enabled = false },
            copilot_node_command = '${pkgs.nodejs}/bin/node',
          }
        '';
      }
      {
        plugin = copilot-cmp;
        type = "lua";
        config = /* lua */ ''
          require('copilot_cmp').setup {}
        '';
      }
    ];
  };
}
