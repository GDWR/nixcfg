# Gnome is installed by the system, this just manages config
{ pkgs, ... }: {
  home.file.".background".source = ../../assets/firewatch.jpg;
  home.file.".face".source = ../../assets/gdwr.png;
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/background" = {
        "picture-uri" = "/home/gdwr/.background";
        "picture-uri-dark" = "/home/gdwr/.background";
      };
      "org/gnome/desktop/screensaver" = {
        "picture-uri" = "/home/gdwr/.background";
        "picture-uri-dark" = "/home/gdwr/.background";
      };
      "org/gnome/desktop/interface" = { "color-scheme" = "prefer-dark"; };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        "custom-keybindings" = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybinding/terminal/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybinding/terminal" =
        {
          "binding" = "<Control><Alt>t";
          "command" = "kgx";
          "name" = "terminal";
        };
    };
  };
}
