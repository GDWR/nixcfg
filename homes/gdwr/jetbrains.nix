{ pkgs, ... }: let
    dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
      sdk_10_0
      sdk_8_0
    ]);
in {
  # Its easier to have these dependencies installed globally with JetBrains IDEs :c 
  home.packages = with pkgs; [
    jetbrains.rider
    dotnetPkg mono

    jetbrains.pycharm
    python3

    jetbrains.idea

    jetbrains.rust-rover
    rustup gcc
  ];
}
