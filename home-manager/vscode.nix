{ pkgs, ... }: {
  programs.direnv.enable = true;  # Used by a vscode plugin

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      vscodevim.vim
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "window.titleBarStyle" = "custom";
    };
  };
}