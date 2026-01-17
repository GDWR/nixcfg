{ pkgs, ... }: {
  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.hyprland.enable = true; # enable Hyprland

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    waybar
    hyprpaper
    hyprpicker
    hyprshot
    hyprlock
    wl-clipboard
  ];


  environment.sessionVariables = {
    ADW_DISABLE_PORTAL = "1";
    TERM = "xterm-256color"; # Kitty is a piece of shit
  };

  services.displayManager.defaultSession = "hyprland";
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude Default Gnome Apps
  environment.gnome.excludePackages = [
    pkgs.baobab      # disk usage analyzer
    pkgs.cheese      # photo booth
    pkgs.eog         # image viewer
    pkgs.epiphany    # web browser
    pkgs.simple-scan # document scanner
    pkgs.totem       # video player
    pkgs.yelp        # help viewer
    pkgs.evince      # document viewer

    # these should be self explanatory
    pkgs.gnome-calculator
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-screenshot
    pkgs.gnome-system-monitor
    pkgs.gnome-weather
    pkgs.gnome-connections
  ];
}
