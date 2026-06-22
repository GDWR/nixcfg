{ self, inputs, ... }: {
  flake.nixosModules.camera = { config, pkgs, lib, ... }:
    let
      cfg = config.gdwr.cameras;

      # v4l2 controls in the order they must be applied. auto_exposure=1 puts
      # the device in manual mode, which is required before
      # exposure_time_absolute will take effect, so it has to come first.
      controlsFor = cam: lib.filter (c: c.value != null) [
        { name = "auto_exposure"; value = cam.autoExposure; }
        { name = "power_line_frequency"; value = cam.powerLineFrequency; }
        { name = "exposure_time_absolute"; value = cam.exposureTimeAbsolute; }
      ];

      # Shell lines that set every configured control on $dev.
      applyControls = cam: lib.concatMapStringsSep "\n"
        (c: ''${pkgs.v4l-utils}/bin/v4l2-ctl -d "$dev" --set-ctrl=${c.name}=${toString c.value} || true'')
        (controlsFor cam);

      # Stable, renumber-proof path for the matched device.
      linkFor = name: "camera-${name}";

      ruleFor = name: cam:
        let
          matchers =
            [ ''ACTION=="add"'' ''SUBSYSTEM=="video4linux"'' ''ATTR{index}=="${toString cam.index}"'' ]
            ++ lib.optional (cam.vendorId != null) ''ATTRS{idVendor}=="${cam.vendorId}"''
            ++ lib.optional (cam.productId != null) ''ATTRS{idProduct}=="${cam.productId}"'';
        in ''${lib.concatStringsSep ", " matchers}, SYMLINK+="${linkFor name}"'';

      # UVC cameras reset their controls to defaults every time an application
      # opens the device (e.g. Teams starting a call), so a one-shot udev RUN
      # doesn't stick. Instead, watch for open() events and re-apply. Apps may
      # also clobber the controls shortly after opening, so re-apply a few times.
      watchScript = name: cam:
        pkgs.writeShellScript "camera-watch-${name}" ''
          dev=/dev/${linkFor name}
          while true; do
            if [ ! -e "$dev" ]; then sleep 2; continue; fi
            ${pkgs.inotify-tools}/bin/inotifywait -qq -e open "$dev" || { sleep 2; continue; }
            for delay in 0.5 1 2; do
              sleep "$delay"
              ${applyControls cam}
            done
          done
        '';
    in {
      options.gdwr.cameras = lib.mkOption {
        default = { };
        description = ''
          v4l2 cameras to configure. Each entry creates a stable /dev symlink
          for the matching device and a service that re-applies the given
          controls whenever the device is opened (UVC cameras reset controls
          to defaults on every open). Controls left unset (null) are omitted.
        '';
        example = lib.literalExpression ''
          {
            webcam = {
              vendorId = "046d";
              productId = "0825";
              autoExposure = 1;
              powerLineFrequency = 1;
              exposureTimeAbsolute = 30;
            };
          }
        '';
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            index = lib.mkOption {
              type = lib.types.int;
              description = "video4linux device index to match (the main capture node is usually 0).";
            };
            vendorId = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "046d";
              description = "USB idVendor to match (from `lsusb`). Omit to match any.";
            };
            productId = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "0825";
              description = "USB idProduct to match (from `lsusb`). Omit to match any.";
            };
            autoExposure = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "auto_exposure ctrl (1 = manual). Required before exposureTimeAbsolute applies.";
            };
            powerLineFrequency = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "power_line_frequency ctrl (0 = disabled, 1 = 50 Hz, 2 = 60 Hz).";
            };
            exposureTimeAbsolute = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "exposure_time_absolute ctrl (in 100 µs units).";
            };
          };
        });
      };

      config = lib.mkIf (cfg != { }) {
        services.udev.extraRules =
          lib.concatStringsSep "\n" (lib.mapAttrsToList ruleFor cfg) + "\n";

        systemd.services = lib.mapAttrs' (name: cam:
          lib.nameValuePair "camera-controls-${name}" {
            description = "Re-apply v4l2 controls to camera '${name}' on open";
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = watchScript name cam;
              Restart = "always";
              RestartSec = 2;
            };
          }) cfg;
      };
    };
}
