{ self, inputs, withSystem, ... }: {
  flake.homeConfigurations.gdwr = withSystem "x86_64-linux" ({ pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.homeModules.hyperland
        self.homeModules.waybar
        self.homeModules.firefox
        self.homeModules.fish
        self.homeModules.git
        self.homeModules.jetbrains
        self.homeModules.neovim
        self.homeModules.tmux
        self.homeModules.vscode

        self.homeModules.gdwrUser

        {
          nixpkgs.config = {
            allowUnfree = true;
          };

          programs.home-manager.enable = true;

          home.file.".background".source = ../../../assets/firewatch.jpg;
          home.file.".face".source = ../../../assets/gdwr.png;

          programs.browserpass.enable = true;
          services.easyeffects.enable = true;

          # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
          home.stateVersion = "23.05";
        }
      ];
    });
}