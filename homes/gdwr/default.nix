{ config, pkgs, inputs, ... }: {
  imports = [
    ./browser.nix
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./hyprland.nix
    ./jetbrains.nix
    ./neovim.nix
    ./tmux.nix
    ./vscode.nix
  ];

  nixpkgs.config = {

    allowUnfree = true;
    overlays = [
      (import ./overlays/vesktop.nix { inherit pkgs; })
    ];
  };

  programs.home-manager.enable = true;

  home = {
    username = "gdwr";
    homeDirectory = "/home/gdwr";
    packages = with pkgs; [
      vesktop
      spotify
      teams-for-linux
      nix-output-monitor
      kgx
      xclip
      remmina
      pass
      nerd-fonts.jetbrains-mono
   ];
  };

  programs.browserpass.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
