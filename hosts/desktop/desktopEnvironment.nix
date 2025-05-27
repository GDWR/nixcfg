{ pkgs, ... }: {
  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = false;
  services.hypridle.enable = true;

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

  services.displayManager.defaultSession = "hyprland";
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
}
