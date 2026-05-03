{ self, inputs, ... }: {
  flake.homeModules.gdwrUser = { pkgs, lib, ... }: {
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
  };
}