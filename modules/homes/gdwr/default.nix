{ self, inputs, withSystem, ... }: {
  flake.homeConfigurations.gdwr = withSystem "x86_64-linux" ({ system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.homeModules.theme
        self.homeModules.waybar
        self.homeModules.firefox
        self.homeModules.fish
        self.homeModules.git
        self.homeModules.jetbrains
        self.homeModules.neovim
        self.homeModules.tmux
        self.homeModules.vscode

        {
          programs.home-manager.enable = true;

          home.file.".background".source = ../../../assets/firewatch.jpg;
          home.file.".face".source = ../../../assets/gdwr.png;
          home = {
            username = "gdwr";
            homeDirectory = "/home/gdwr";
            sessionPath = [ "/home/gdwr/.local/bin" ];
            packages = with pkgs; [
              vesktop
              spotify
              playerctl
              teams-for-linux
              nix-output-monitor
              xclip
              remmina
              pass
              crosspipe
              nautilus
              easyeffects
              nerd-fonts.jetbrains-mono
              obs-studio

              claude-code
              sox

              fd
              ripgrep
            ];
          }; 

          programs.browserpass.enable = true;
          services.easyeffects.enable = true;

          # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
          home.stateVersion = "23.05";
        }
      ];
    });
}