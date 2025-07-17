{ pkgs, ... }: let
    dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
      sdk_9_0
      sdk_8_0
    ]);
in {
  nixpkgs.overlays = [(import ./overlays/jetbrains.nix { system = pkgs.system; pkgs = pkgs; })];

  # Its easier to have these dependencies installed globally with JetBrains IDEs :c 
  home.packages = with pkgs; [
    jetbrains.rider
    dotnetPkg mono

    jetbrains.pycharm-professional
    python3

    jetbrains.idea-ultimate

    jetbrains.rust-rover
    rustup gcc
  ];
}
