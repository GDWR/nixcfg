{  config, pkgs, inputs, ... }:
{
  imports = [
    ./git.nix
    ./gnome.nix
    ./jetbrains.nix
    ./neovim.nix
    ./nushell.nix
    ./tmux.nix
    ./vscode.nix
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
    packages = with pkgs; [
      inputs.plate.packages.x86_64-linux.plate
      btop
      google-chrome
      discord
      ncdu
      spotify
      teams-for-linux
      nix-output-monitor
      fzf

      dotnet-sdk_8
      mono
    ];
  };

  programs.direnv.enable = true;
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
