{ pkgs, ... }:

{
  imports = [ ./prompt.nix ];

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    syntaxHighlighting.enable = true;

    autocd = true;

    history.extended = true;

    historySubstringSearch = {
      enable = true;
    };

    shellAliases = {
      # Shell
      e = "$EDITOR $*";
      se = "sudo nvim";
      j = "jobs";
      o = if pkgs.stdenv.isLinux then "xdg-open" else "open";
      c = if pkgs.stdenv.isLinux then "wl-copy" else "pbcopy";
      p = if pkgs.stdenv.isLinux then "wl-paste" else "pbpaste";

      # Nix
      ns = "nix-shell -p $@ --run zsh";
      nr = "nix repl";
      nd = "nix build nixpkgs#nixpkgs-manual --no-link --print-out-paths | xargs -I{} ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} {}/share/doc/nixpkgs/manual.html";

      # NixOS
      sne = "se /etc/nixos/configuration.nix";
      snf = "sudo nixos-rebuild switch --fast";
      snu = "sudo nix flake update --flake /etc/nixos && nh os switch";

      # Home Manager
      hm = "home-manager";
      hme = "home-manager edit";
      hmu = "nh home switch -u";

      # Git
      ga = "git add -p";
      gn = "git add -N .";
      gb = "git branch";
      gc = "git commit -v";
      gco = "git checkout";
      gd = "git diff --color";
      gdn = "git diff --name-only";
      gds = "git diff --staged --color";
      gl = "git pull --prune && git delete-local-merged";
      glog = "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cd)%Creset' --date=relative";
      gla = "glog --all";
      gp = "git push origin HEAD";
      gs = "git status -sb";
      gst = "git stash";

      # Misc
      ts = "toastify send";
      qr = "qrscan";
      qw = "qrtool encode -t terminal";

      # Tmux
      txl = "tmux ls";
      txn = "tmux new -A -s $*";
      txa = "tmux attach";
      txe = "txn $(basename $PWD) nvim . +\"vert Git\"";
      txb = "${pkgs.ttyd}/bin/ttyd -W -i 127.0.0.1 -q -t fontFamily='UbuntuMono Nerd Font' -t fontSize=18 -B tmux attach";
    };

    initContent = ''
      # Extra options
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      unsetopt BEEP

      # Force emacs mode
      bindkey -e

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    '';
  };
}
