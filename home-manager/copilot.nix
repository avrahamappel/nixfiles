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
    home.packages = with pkgs; [
      github-copilot-cli
      lynx # copilot chat wants this
    ];

    # Shell aliases for github-copilot-cli
    programs.zsh.initExtra = ''
      eval "$(${pkgs.github-copilot-cli}/bin/github-copilot-cli alias -- "$0")"
    '';

    programs.neovim.extraLuaPackages = ps: with ps; [
      tiktoken_core # Optional dependency of CopilotChat-nvim
    ];

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
      {
        plugin = CopilotChat-nvim;
        type = "lua";
        config = /* lua */ ''
          require('CopilotChat').setup {}
        '';
      }
    ];
  };
}
