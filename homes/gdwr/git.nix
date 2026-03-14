{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "GDWR";
        email = "gregory.dwr@gmail.com";
      };
      init = { defaultBranch = "main"; };
      pull = { rebase = true; };
      push = { autoSetupRemote = true; };
      rebase = { autoStash = true; };
    };
    signing = {
      key = "AA50DFAD8C88A6DE";
      signByDefault = true;
    };
  };
}
