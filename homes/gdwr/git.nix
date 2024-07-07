{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "GDWR";
    userEmail = "gregory.dwr@gmail.com";
    signing = {
      key = "AA50DFAD8C88A6DE";
      signByDefault = true;
    };
    extraConfig = {
	  init = { defaultBranch = "main"; };
      pull = { rebase = "true"; };
    };
  };
}
