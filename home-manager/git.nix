{
  programs.git = {
    enable = true;

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
      ".luarc.json"
      ".vagrant"
      "tags*"
      ".direnv"
      ".envrc"
      ".vimrc.lua"
    ];

    includes = [
      { path = "~/.gitconfig.local"; }
    ];

    aliases = {
      delete-local-merged = "! git branch -d $(git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\\n') 2> /dev/null";
    };

    extraConfig = {
      branch.sort = "-committerdate"; # Sort branches by most recently updated

      commit.verbose = true; # Always show a full diff in the commit message screen

      diff = { # Smarter diffs
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
      };

      fetch = {
        prune = true;     # Prune deleted branches
        pruneTags = true; # Prune deleted tags
      };

      init.defaultBranch = "master";

      merge.tool = "nvimdiff";
      mergetool.keepBackup = false;

      pull.ff = "only";

      push.autoSetupRemote = true;

      rerere = { # Reuse Recorded Resolutions, don't resolve the same conflicts over and over
        enabled = true;
        autoupdate = true;
      };

      tag.sort = "version:refname"; # Sort semver tags correctly
    };

    # difftastic = {
    #   enable = true;
    #   # This option is somewhat oddly named. I'm telling it to use bright colors.
    #   background = "dark";
    # };
  };
}
