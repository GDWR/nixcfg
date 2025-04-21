{ pkgs, ... }: let
    dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
      sdk_9_0
      sdk_8_0
    ]);
in {
  # Its easier to have these dependencies installed globally with JetBrains IDEs :c 
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot"])
    dotnetPkg mono

    (jetbrains.plugins.addPlugins jetbrains.pycharm-professional ["github-copilot"])
    python3

    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot"])
  ];
}
