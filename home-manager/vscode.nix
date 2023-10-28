{ pkgs, ... }: {
  programs.direnv.enable = true;  # Used by a vscode plugin

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      vscodevim.vim
    ];
    # https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.userSettings
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "window.titleBarStyle" = "custom";
      "git.autofetch" = true;
      "editor.minimap.enabled" = false;
      "editor.smoothScrolling" = true;
      "editor.mouseWheelZoom" = true;
      "editor.fontLigatures" = true;
      "explorer.autoReveal" = true;
      "debug.toolBarLocation" = "docked";

      "terminal.integrated.defaultProfile.linux" = "nu";
      "terminal.integrated.profiles.linux" = {
        "nu" = {
          "path" = "/home/gdwr/.nix-profile/bin/nu";
        };
      };
    };
  };
}