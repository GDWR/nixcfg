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
    ./waybar.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
 
  nixpkgs.overlays = [
    (import ./overlays/jetbrains.nix { system = pkgs.system; })
  ];

  programs.home-manager.enable = true;

  home = {
    username = "gdwr";
    homeDirectory = "/home/gdwr";
    packages = with pkgs; [
      vesktop
      spotify
      playerctl
      teams-for-linux
      nix-output-monitor
      kgx
      xclip
      remmina
      pass
      helvum
      nerd-fonts.jetbrains-mono
   ];
   pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
   };
  };

  programs.browserpass.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
