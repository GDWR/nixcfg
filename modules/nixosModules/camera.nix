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

      # Set every configured control in a single v4l2-ctl call (one device
      # open). Setting controls on an actively-streaming UVC device stalls the
      # stream, so opening it once rather than once-per-control avoids lag.
      # Controls are comma-separated and applied left-to-right, preserving the
      # required order (auto_exposure before exposure_time_absolute).
      applyControls = cam:
        let ctrls = controlsFor cam;
        in lib.optionalString (ctrls != [ ]) ''
          ${pkgs.v4l-utils}/bin/v4l2-ctl -d "$dev" --set-ctrl=${
            lib.concatMapStringsSep "," (c: "${c.name}=${toString c.value}") ctrls
          } || true'';

      # Stable, renumber-proof path for the matched device.
      linkFor = name: "camera-${name}";

      ruleFor = name: cam:
        let
          matchers =
            [ ''ACTION=="add"'' ''SUBSYSTEM=="video4linux"'' ''ATTR{index}=="${toString cam.index}"'' ]
            ++ lib.optional (cam.vendorId != null) ''ATTRS{idVendor}=="${cam.vendorId}"''
            ++ lib.optional (cam.productId != null) ''ATTRS{idProduct}=="${cam.productId}"'';
        in ''${lib.concatStringsSep ", " matchers}, SYMLINK+="${linkFor name}"'';

      # UVC cameras reset their controls to defaults whenever an application
      # opens the device (e.g. Teams starting a call), so a one-shot udev RUN
      # doesn't stick. Watching open() events and re-applying causes a feedback
      # loop: our v4l2-ctl access makes PipeWire/WirePlumber re-probe the device,
      # which we'd see as another open. Instead poll with fuser (which inspects
      # /proc and does NOT open the device) and apply once when a real consumer
      # holds it across two consecutive polls — long enough to skip the brief
      # automatic probes. applied resets when the device goes idle, so the next
      # consumer re-applies.
      watchScript = name: cam:
        pkgs.writeShellScript "camera-watch-${name}" ''
          dev=/dev/${linkFor name}
          busyPrev=0
          applied=0
          echo "polling $dev for sustained use"
          while true; do
            if ${pkgs.psmisc}/bin/fuser "$dev" >/dev/null 2>&1; then busy=1; else busy=0; fi
            if [ "$busy" = 1 ] && [ "$busyPrev" = 1 ] && [ "$applied" = 0 ]; then
              ${applyControls cam}
              applied=1
              echo "consumer using $dev; controls applied"
            fi
            [ "$busy" = 0 ] && applied=0
            busyPrev=$busy
            sleep ${toString cam.pollSeconds}
          done
        '';
    in {
      options.gdwr.cameras = lib.mkOption {
        default = { };
        description = ''
          v4l2 cameras to configure. Each entry creates a stable /dev symlink
          for the matching device and a service that applies the given controls
          once a consumer starts using it (UVC cameras reset controls to
          defaults on open). Controls left unset (null) are omitted.
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
            pollSeconds = lib.mkOption {
              type = lib.types.int;
              default = 2;
              description = ''
                How often (seconds) to poll whether a consumer is using the
                device. A consumer must be present for two consecutive polls
                before controls are applied, so this also sets how long a use
                must last to count (vs. brief automatic probes).
              '';
            };
          };
        });
      };

      config = lib.mkIf (cfg != { }) {
        services.udev.extraRules =
          lib.concatStringsSep "\n" (lib.mapAttrsToList ruleFor cfg) + "\n";

        systemd.services = lib.mapAttrs' (name: cam:
          lib.nameValuePair "camera-controls-${name}" {
            description = "Apply v4l2 controls to camera '${name}' when in use";
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
