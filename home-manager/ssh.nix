{
  programs.ssh = {
    enable = true;
    # Add key passwords to agent after they are entered once
    addKeysToAgent = "yes";
  };
}
