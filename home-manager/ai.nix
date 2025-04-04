{ pkgs, lib, config, ... }:

let
  cfg = config.user.ai;
in

{
  options.user.ai = {
    enable = (lib.mkEnableOption "ai / copilot") // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.extraLuaPackages = ps: with ps; [
      tiktoken_core # Optional dependency of CopilotChat-nvim
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      copilot-lua
      copilot-cmp
      CopilotChat-nvim
    ];
  };
}
