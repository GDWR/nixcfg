{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName  = "GDWR";
    userEmail = "gregory.dwr@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}