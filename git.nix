{ ... }:

{
  enable = true;

  ignores = [
    ".DS_Store"
    "*~"
    "*.swp"
    ".idea"
    "_ide_helper.php"
    ".luarc.json"
    ".phpstorm.meta.php"
    "*.sublime-*"
    ".vagrant"
    "tags*"
  ];

  includes = [
    { path = "~/.gitconfig.local"; }
  ];

  extraConfig = {
    push = {
      # See `git help config` (search for push.default)
      # for more information on different options of the below setting.
      #
      # Setting to git 2.0 default to suppress warning message
      default = "simple";
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

    # Use diffr for interactive mode (e.g. git add -p)
    # difftastic doesn't support this yet
    interactive = {
      diffFilter = "diffr";
    };
  };

  difftastic = {
    enable = true;
    # This option is somewhat oddly named. I'm telling it to use bright colors.
    background = "dark";
  };
}
