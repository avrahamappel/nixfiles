{ pkgs, lib, config, ... }:

let
  cfg = config.user.copilot;

  npins = import ../npins;

  codecompanion-spinner-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion-spinner.nvim";
    version = npins."codecompanion-spinner.nvim".version;
    src = npins."codecompanion-spinner.nvim";
    meta.homepage = "https://github.com/franco-ruggeri/codecompanion-spinner.nvim";
  };

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
      codecompanion-spinner-nvim
      {
        plugin = codecompanion-nvim;
        type = "lua";
        config = /* lua */ ''
          require("codecompanion").setup({
            extensions = {
              history = {
                enable = true
              },
              spinner = {},
            }
          })

          vim.api.nvim_set_keymap('n', '<leader>c', ':CodeCompanion', {})
        '';
      }
    ];
  };
}
