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

    settings = {
      aliases.delete-local-merged = "! git branch -d $(git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\\n') 2> /dev/null";

      branch.sort = "-committerdate"; # Sort branches by most recently updated

      commit.verbose = true; # Always show a full diff in the commit message screen

      # Smarter diffs
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
      };

      fetch = {
        prune = true; # Prune deleted branches
        pruneTags = true; # Prune deleted tags
      };

      init.defaultBranch = "master";

      merge.tool = "nvimdiff";
      mergetool.keepBackup = false;

      pull.ff = "only";

      push.autoSetupRemote = true;

      # Reuse Recorded Resolutions, don't resolve the same conflicts over and over
      rerere = {
        enabled = true;
        autoupdate = true;
      };

      tag.sort = "version:refname"; # Sort semver tags correctly
    };
  };
}
