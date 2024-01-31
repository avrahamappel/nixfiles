{ ... }:

{
  enable = true;

  enableAutosuggestions = true;

  syntaxHighlighting.enable = true;

  autocd = true;

  history.extended = true;

  historySubstringSearch.enable = true;

  shellAliases = {
    # Shell
    e = "$EDITOR $*";
    j = "jobs";

    # Nix
    ns = "nix-shell -p $@ --run zsh";
    nr = "nix repl";

    # Home Manager
    hm = "home-manager";
    hme = "cd ${builtins.toString ../.}; e home.nix";
    hmu = "nix-channel --update; home-manager switch; home-manager packages | sort > ${builtins.toString ../.}/packages.txt";

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

    # Tmux
    tx = "tmux";
    txn = "tmux new -A -s $*";
    txa = "tmux attach";
    txe = "txn $(basename $PWD) nvim . +\"vert Git\"";
    txb = "ttyd -W -p 0 -t fontFamily='UbuntuMono Nerd Font' -t fontSize=18 -B tmux attach";
  };

  initExtraFirst = ''
    # Prompt customization
    source ${builtins.toString ./prompt.zsh}
  '';

  initExtra = ''
    # Extra options
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_REDUCE_BLANKS
    unsetopt BEEP

    # Case-insensitive completion
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

    # Local customization
    source ${builtins.toString ./local.zsh}
  '';
}
