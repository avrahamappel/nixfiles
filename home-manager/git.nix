{
  programs.git = {
    enable = true;

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
      ".idea"
      "_ide_helper.php"
      ".luarc.json"
      ".null-ls_*"
      ".phpstorm.meta.php"
      "*.sublime-*"
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
      push = {
        # See `git help config` (search for push.default)
        # for more information on different options of the below setting.
        #
        # Setting to git 2.0 default to suppress warning message
        default = "simple";

        autoSetupRemote = true;
      };

      commit = {
        # Always show a full diff in the commit message screen
        verbose = true;
      };

      init = {
        defaultBranch = "master";
      };

      merge = {
        tool = "nvimdiff";
      };

      mergetool = {
        keepBackup = false;
      };

      pull = {
        ff = "only";
      };
    };

    difftastic = {
      enable = true;
      # This option is somewhat oddly named. I'm telling it to use bright colors.
      background = "dark";
    };
  };
}
