{ config, pkgs, ... }: {
  imports = [
    ./bash.nix
    ./git.nix
    ./gnome.nix
    ./jetbrains.nix
    ./neovim.nix
    ./tmux.nix
    ./vscode.nix
  ];

  nixpkgs.overlays = [
    (import ./overlays/dotnet_sdk_5_0.nix { system = pkgs.system; })
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  home = {
    username = "gdwr";
    homeDirectory = "/home/gdwr";
    packages = with pkgs; [
      btop
      discord
      ncdu
      spotify
      teams-for-linux
      nix-output-monitor
      fzf

      jetbrains-mono
      nerdfonts
   ];
  };

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
