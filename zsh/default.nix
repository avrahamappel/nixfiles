{ ... }:

{
  enable = true;

  enableAutosuggestions = true;

  enableSyntaxHighlighting = true;

  autocd = true;

  historySubstringSearch.enable = true;

  shellAliases = {
    # Shell
    e = "f() { $EDITOR \${1:-.} };f";
    j = "jobs";

    # Nix
    ns = "nix-shell -p $@";
    nr = "nix repl";

    # Home Manager
    hm = "home-manager";
    hme = "cd ${builtins.toString ../.}; home-manager edit";

    # Git
    ga = "git add -p";
    gn = "git add -N .";
    gb = "git branch";
    gc = "git commit -v";
    gco = "git checkout";
    gd = "git diff --color";
    gdn = "git diff --name-only";
    gds = "git diff --staged --color";
    gl = "git pull --prune && git-delete-local-merged";
    glog = "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cd)%Creset' --date=relative";
    gla = "glog --all";
    gp = "git push origin HEAD";
    gs = "git status -sb";
    gst = "git stash";

    # Tmux
    tx = "tmux";
    txa = "tmux attach";
  };

  initExtraFirst = ''
    source ${builtins.toString ./prompt.zsh}
  '';

  initExtra = ''
    source ${builtins.toString ./local.zsh}
  '';

  localVariables = {
    EDITOR = "nvim";
  };
}
