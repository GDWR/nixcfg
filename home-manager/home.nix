{  config, pkgs, ... }: {
  imports = [
    ./git.nix
    ./gnome.nix
    ./neovim.nix
    ./nushell.nix
    ./starship.nix
    ./vscode.nix
  ];

  nixpkgs.overlays = [

    # https://github.com/NixOS/nixpkgs/pull/267617
    (final: prev: {
      dotnet-sdk_8 = prev.dotnet-sdk_8.overrideAttrs (oldAttrs: {
        version = "8.0.100";
        src = pkgs.fetchurl {
          url     = "https://download.visualstudio.microsoft.com/download/pr/5226a5fa-8c0b-474f-b79a-8984ad7c5beb/3113ccbf789c9fd29972835f0f334b7a/dotnet-sdk-8.0.100-linux-x64.tar.gz";
          sha512  = "13905ea20191e70baeba50b0e9bbe5f752a7c34587878ee104744f9fb453bfe439994d38969722bdae7f60ee047d75dda8636f3ab62659450e9cd4024f38b2a5";
        };
      });
    })
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
      google-chrome
      discord
      helix
      ncdu
      spotify
      teams-for-linux
      jetbrains.webstorm

      jetbrains.rider
      dotnet-sdk_8

      (jetbrains.plugins.addPlugins jetbrains.pycharm-professional [ "17718" ])
      python311
      pdm

      jetbrains.goland
    ];
  };

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
