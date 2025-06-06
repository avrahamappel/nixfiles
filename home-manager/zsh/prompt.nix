{ lib, ... }:

{
  programs.zsh.initContent = lib.mkBefore ''
    # Prompt customization
    source ${./prompt.zsh}
  '';
}
