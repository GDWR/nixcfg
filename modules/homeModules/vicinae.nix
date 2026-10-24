{ self, inputs, ... }: {
  flake.homeModules.vicinae = { pkgs, lib, ... }: {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme.dark.name = "vicinae-dark";
        font.normal.family = "JetBrainsMono Nerd Font";

        # Hyprland owns the launcher keybind (see hyprland.lua), so drop
        # vicinae's own global toggle shortcut.
        global_shortcuts.toggle = "";
      };
    };
  };
}
