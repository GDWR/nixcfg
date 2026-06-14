{ self, inputs, withSystem, ... }: {
  flake.homeConfigurations.work = withSystem "x86_64-linux" ({ system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "vscode"
          "rider"
          "pycharm"
          "claude-code"
          "copilot.vim"
        ];
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
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
              teams-for-linux
              remmina
              crosspipe
              nerd-fonts.jetbrains-mono
              obs-studio

              self.packages.${system}.claude-code
              sox

              fd
              ripgrep
            ];
          }; 

          # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
          home.stateVersion = "23.05";

          # We intentionally track nixpkgs nixos-unstable + home-manager master,
          # whose version strings drift apart; skip the release-match check.
          home.enableNixpkgsReleaseCheck = false;
        }
      ];
    });
}