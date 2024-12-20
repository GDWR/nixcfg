{ pkgs, ... }: {
  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      vscodevim.vim
      jnoortheen.nix-ide
      github.copilot
      ms-vscode-remote.remote-containers
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      cweijan.vscode-database-client2
      ms-python.python
    ];

    # https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.userSettings
    userSettings = {
      "debug.toolBarLocation" = "docked";
      "git.autofetch" = true;
      "explorer.autoReveal" = true;
      "files.autoSave" = "onFocusChange";
      "window.titleBarStyle" = "custom";
      "workbench.tree.indent" = 18;
      "workbench.tree.renderIndentGuides" = "always";

      "editor.minimap.enabled" = false;
      "editor.smoothScrolling" = true;
      "editor.mouseWheelZoom" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "JetBrains Mono";

      "terminal.integrated.fontFamily" = "JetBrains Mono";
    };
  };
}
