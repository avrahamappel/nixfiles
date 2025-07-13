{ pkgs, lib, config, ... }:

let
  cfg = config.user.copilot;
in

{
  options.user.copilot = {
    enable = (lib.mkEnableOption "copilot") // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      codecompanion-history-nvim
      {
        plugin = codecompanion-nvim;
        type = "lua";
        config = /* lua */ ''
          require("codecompanion").setup({
            extensions = {
              history = {
                enable = true
              }
            }
          })

          vim.api.nvim_set_keymap('n', '<leader>c', ':CodeCompanion', {})
        '';
      }
    ];
  };
}
