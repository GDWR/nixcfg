{ self, inputs, ... }: {
  flake.nixosModules.hyprland = { config, pkgs, lib, ... }:
    let
      cfg = config.gdwr.hyprland;
      monitorLines = lib.concatMapStringsSep "\n" (m: "monitor=${m}") cfg.monitors;
    in {
      options.gdwr.hyprland.monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "DP-1, 2560x1440@165, auto, 1" ];
        description = ''
          Hyprland monitor configuration lines. Each entry is the value that
          follows `monitor=` in hyprland.conf.
        '';
      };

      config = {
        programs.hyprland = {
          enable = true;
          withUWSM = false;
        };

        services.xserver.enable = true;
        services.greetd = {
          enable = true;
          settings.default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.hyprland.package}/bin/start-hyprland";
            user = "greeter";
          };
        };

        environment.systemPackages = with pkgs; [
          kitty
          rofi
          hyprpaper
          hyprpicker
          hyprshot
          hyprlock
          wl-clipboard
        ];

        environment.etc."hypr/hyprland.conf".text =
          monitorLines + "\n\n" + builtins.readFile ./hyprland.conf;
        environment.etc."hypr/hyprlock.conf".source = ./hyprlock.conf;
        environment.etc."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

        environment.sessionVariables.HYPRLAND_CONFIG = "/etc/hypr/hyprland.conf";
      };
    };
}
