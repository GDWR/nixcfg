{ self, inputs, ... }: {
  flake.nixosModules.hyprland = { config, pkgs, lib, ... }:
    let
      cfg = config.gdwr.hyprland;
      monitorLine = m:
        let
          fields = map lib.trim (lib.splitString "," m);
          keys = [ "output" "mode" "position" "scale" ];
        in
        "hl.monitor({ "
        + lib.concatStringsSep ", "
          (lib.zipListsWith (k: v: "${k} = ${builtins.toJSON v}") keys fields)
        + " })";
      monitorLines = lib.concatMapStringsSep "\n" monitorLine cfg.monitors;
    in {
      options.gdwr.hyprland.monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "DP-1, 2560x1440@165, auto, 1" ];
        description = ''
          Hyprland monitor configuration lines in the legacy
          `output, mode, position, scale` form. Each entry is turned into an
          `hl.monitor({ ... })` call in hyprland.lua.
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
          hyprpaper
          hyprpicker
          hyprshot
          hyprlock
          wl-clipboard
        ];

        environment.etc."hypr/hyprland.lua".text =
          monitorLines + "\n\n" + builtins.readFile ./hyprland.lua;
        environment.etc."hypr/hyprlock.conf".source = ./hyprlock.conf;
        environment.etc."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

        environment.sessionVariables.HYPRLAND_CONFIG = "/etc/hypr/hyprland.lua";

        # xdg-desktop-portal >= 1.22 refuses to start unless
        # graphical-session.target is active, and Hyprland without UWSM never
        # activates it. That target is RefuseManualStart, so bind it to a
        # session target Hyprland can start itself (see the hyprland.start
        # handler in hyprland.lua). Without this, screen sharing has no ScreenCast portal.
        systemd.user.targets.hyprland-session = {
          description = "Hyprland compositor session";
          documentation = [ "man:systemd.special(7)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
        };
      };
    };
}
