{ config, pkgs, inputs, ... }: {
  imports = [
    ./browser.nix
    ./fish.nix
    ./git.nix
    ./hyprland.nix
    ./jetbrains.nix
    ./neovim.nix
    ./poe.nix
    ./tmux.nix
    ./vscode.nix
    ./waybar.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
 
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
      nautilus
      easyeffects
      nerd-fonts.jetbrains-mono
      obsidian
   ];
   pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
   };
  };

  home.file.".background".source = ../../assets/firewatch.jpg;
  home.file.".face".source = ../../assets/gdwr.png;

  programs.browserpass.enable = true;
  services.easyeffects.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
