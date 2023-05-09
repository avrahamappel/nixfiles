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
    nr = "nix repl '<nixpkgs>'";

    # Home Manager
    hm = "home-manager";
    hme = "cd ${builtins.toString ../.}; home-manager edit";

    # Git
    ga = "git add";
    gap = "git add -p";
    gan = "git -N .";
    gb = "git branch";
    gc = "git commit -v";
    gco = "git checkout";
    gd = "git diff --color";
    gdn = "git diff --name-only";
    gds = "git diff --staged --color";
    git-delete-local-merged = "git branch -d $(git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\\n') 2> /dev/null";
    gl = "git pull --prune && git-delete-local-merged";
    glog = "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cd)%Creset' --date=relative";
    gla = "glog --all";
    gp = "git push origin HEAD";
    gs = "git status -sb";
    gst = "git stash";
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
