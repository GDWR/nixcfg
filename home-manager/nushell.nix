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
        keybindings: [
          {
            name: fuzzy_find 
            modifier: control
            keycode: char_f
            mode: emacs
            event: {
              send: executehostcommand,
              cmd: "commandline --insert (fzf | decode utf-8 | str trim)"
            }
          }
        ],
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