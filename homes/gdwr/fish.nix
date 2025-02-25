{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      
      source ${pkgs.fzf}/share/fzf/key-bindings.fish
    '';

    shellAbbrs = {
      d = "docker";
      dc = "docker compose";
      t = "tmux";
      e = "nvim";
      n = "nvim";
      hm = "home-manager";
      g = "git";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.direnv.enable = true;
}
