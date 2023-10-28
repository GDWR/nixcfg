# Gnome is installed by the system, this just manages config
{ ... }: {
  home.file.".background".source = ./backgrounds/firewatch.jpg;
  dconf.settings = {
    "org/gnome/desktop/background" = {
        "picture-uri" = "/home/gdwr/.background";
	"picture-uri-dark" = "/home/gdwr/.background";
    };
    "org/gnome/desktop/screensaver" = {
        "picture-uri" = "/home/gdwr/.background";
	"picture-uri-dark" = "/home/gdwr/.background";
    };
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
    };
  };
}