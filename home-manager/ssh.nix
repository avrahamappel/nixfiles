{
  programs.ssh.enable = true;

  programs.ssh.enableDefaultConfig = false;

  programs.ssh.matchBlocks."*" = {
    forwardAgent = false;
    # Add key passwords to agent after they are entered once
    addKeysToAgent = "yes";
    compression = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    controlMaster = "no";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
  };
}
