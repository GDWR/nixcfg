{ config, pkgs, inputs, ... }: {
  imports = [
    ./browser.nix
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./jetbrains.nix
    ./neovim.nix
    ./tmux.nix
    ./vscode.nix
  ];

  nixpkgs.config = {
    overlays = [
      (import ./overlays/vesktop.nix { inherit pkgs; })
    ];
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;

  home = {
    username = "gdwr";
    homeDirectory = "/home/gdwr";
    packages = with pkgs; [
      btop
      vesktop
      ncdu
      spotify
      teams-for-linux
      nix-output-monitor
      fzf
      kgx
      xclip
      remmina
      pass
      nerd-fonts.jetbrains-mono
   ];
  };

  programs.browserpass.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
