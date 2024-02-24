{ pkgs, ... }: let
    copilotPlugin = "17718";
    plugins = [ copilotPlugin ];
in {
    home.packages = with pkgs; [
      (jetbrains.plugins.addPlugins jetbrains.clion plugins)
      (jetbrains.plugins.addPlugins jetbrains.webstorm plugins)      
      (jetbrains.plugins.addPlugins jetbrains.rust-rover plugins)
      (jetbrains.plugins.addPlugins jetbrains.rider plugins)
      (jetbrains.plugins.addPlugins jetbrains.pycharm-professional plugins)
      (jetbrains.plugins.addPlugins jetbrains.goland plugins)
      (jetbrains.plugins.addPlugins jetbrains.idea-ultimate plugins)
    ];
}