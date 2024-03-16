{ pkgs, ... }: let
    copilotPlugin = "17718";
    plugins = [ copilotPlugin ];
in {
    home.packages = with pkgs; [
      (jetbrains.plugins.addPlugins jetbrains.rider plugins)
      (jetbrains.plugins.addPlugins jetbrains.pycharm-professional plugins)
    ];
}