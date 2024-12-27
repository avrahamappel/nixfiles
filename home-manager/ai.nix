{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = copilot-vim;
        config = /* vim */ ''
          "start with copilot disabled, with a map to reenable
          Copilot disable
          map <leader>i :Copilot enable<CR>
        '';
      }
    ];
  };
}
