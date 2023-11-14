{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName  = "GDWR";
    userEmail = "gregory.dwr@gmail.com";
    signing = {
      key = "0E5FCBA09A4F5ED5";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}