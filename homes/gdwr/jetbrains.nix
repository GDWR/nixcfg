{ pkgs, ... }: let
    # Copilot struggles when installing via jetbrains plugin manager
    copilotPlugin = "17718";
    plugins = [ copilotPlugin ];
    dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
      sdk_9_0
      sdk_8_0
    ]);
in {
  # Its easier to have these dependencies installed globally with JetBrains IDEs :c 
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.rider plugins)
    dotnetPkg mono

    (jetbrains.plugins.addPlugins jetbrains.pycharm-professional plugins)
    python3

    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate plugins)
  ];
}
