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
      {
        plugin = codecompanion-nvim;
        type = "lua";
        config = /* lua */ ''
          require("codecompanion").setup({
            extensions = {
              history = {
                enable = true
              },
            }
          })

          vim.api.nvim_set_keymap('n', '<leader>c', ':CodeCompanion', {})
        '';
      }
    ];
  };
}
