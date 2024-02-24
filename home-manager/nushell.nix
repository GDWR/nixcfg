# Nushell set as default in nixos/configuration.nix
{ ... }: {
  programs.nushell = {
    enable = true;
    environmentVariables = {
      EDITOR = "nvim";
    };
    extraConfig = ''
      $env.config = {
        show_banner: false,
       }

       alias d = docker
       alias dc = docker compose
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}