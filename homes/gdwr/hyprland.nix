{ pkgs, ... }: {
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  # Add hyprland.conf
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;
  home.file.".config/hyprland/hyprlock.conf".source = ./hyprlock.conf;
}
