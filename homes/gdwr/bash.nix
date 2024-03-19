{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      d = "docker";
      dc = "docker compose";
      t = "tmux";
      e = "nvim";
      n = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
