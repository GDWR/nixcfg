{  inputs,  lib,  config,  pkgs,  ... }: {
  imports = [
    ./git.nix
    ./gnome.nix
    ./neovim.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "electron-24.8.6" # Yikes...
    ];
  };

  home = {
    username = "gdwr";
    homeDirectory = "/home/gdwr";
    packages = [
      pkgs.discord
      pkgs.helix
      pkgs.teams-for-linux
    ];
  };

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.nushell.enable = true;
  programs.vscode.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
