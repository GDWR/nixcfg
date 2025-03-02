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
      "org/gnome/desktop/interface" = {
        "color-scheme" = "prefer-dark"; 
        "gtk-theme" = "Adwaita-dark";
      };
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

  
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = { 
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
