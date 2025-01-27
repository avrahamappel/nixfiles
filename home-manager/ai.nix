{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = copilot-vim;
        config = /* vim */ ''
          " Maps to enable and disable Copilot
          map <leader>ii :Copilot enable<CR>
          map <leader>io :Copilot disable<CR>
        '';
      }
      {
        plugin = cmp-copilot;
      }
    ];
  };
}
