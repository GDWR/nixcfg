{ pkgs, ... }: {
  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

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
  services.displayManager.gdm.enable = true;
  services.xserver.enable = true;
}
