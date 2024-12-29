{ pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = copilot-vim;
        config = /* vim */ ''
          "start with copilot disabled, with maps to toggle
          let g:coplot_filetypes = { '*': v:false }
          map <leader>ii :Copilot enable<CR>
          map <leader>io :Copilot disable<CR>
        '';
      }
    ];
  };
}
