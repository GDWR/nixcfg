{  inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.jetpack.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  nixpkgs.overlays = [ 
    # patch openvino to avoid compilation errors
    #  https://github.com/NixOS/nixpkgs/pull/288136
    (final: prev: {
      openvino = prev.openvino.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.scons ];

        dontUseSconsCheck = true;
        dontUseSconsBuild = true;
        dontUseSconsInstall = true;

        cmakeFlags = [
          "-Wno-dev"
          "-DCMAKE_MODULE_PATH:PATH=${placeholder "out"}/lib/cmake"
          "-DCMAKE_PREFIX_PATH:PATH=${placeholder "out"}"
          "-DOpenCV_DIR=${pkgs.opencv}/lib/cmake/opencv4/"
          "-DProtobuf_LIBRARIES=${pkgs.protobuf}/lib/libprotobuf${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"

          (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
          (lib.cmakeBool "NCC_SYLE" false)
          (lib.cmakeBool "BUILD_TESTING" false)
          (lib.cmakeBool "ENABLE_CPPLINT" false)
          (lib.cmakeBool "ENABLE_TESTING" false)
          (lib.cmakeBool "ENABLE_SAMPLES" false)

          # features
          (lib.cmakeBool "ENABLE_INTEL_CPU" false)
          (lib.cmakeBool "ENABLE_INTEL_GNA" false)
          (lib.cmakeBool "ENABLE_JS" false)
          (lib.cmakeBool "ENABLE_LTO" true)
          (lib.cmakeBool "ENABLE_ONEDNN_FOR_GPU" false)
          (lib.cmakeBool "ENABLE_OPENCV" true)
          (lib.cmakeBool "ENABLE_PYTHON" true)

          # system libs
          (lib.cmakeBool "ENABLE_SYSTEM_FLATBUFFERS" true)
          (lib.cmakeBool "ENABLE_SYSTEM_OPENCL" true)
          (lib.cmakeBool "ENABLE_SYSTEM_PROTOBUF" false)
          (lib.cmakeBool "ENABLE_SYSTEM_PUGIXML" true)
          (lib.cmakeBool "ENABLE_SYSTEM_SNAPPY" true)
          (lib.cmakeBool "ENABLE_SYSTEM_TBB" true)
        ];
      });
    })
  ];

  nix = {
    optimise.automatic = true;
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = [ "root" "gdwr" ];  
    };
  };

  networking.hostName = "xavier";

  hardware.nvidia-jetpack.enable = true;
  hardware.nvidia-jetpack.som = "xavier-agx"; # Other options include orin-agx, xavier-nx, and xavier-nx-emmc
  hardware.nvidia-jetpack.carrierBoard = "devkit";
  hardware.enableAllFirmware = true;
  services.nvfancontrol.enable = true;
  services.nvpmodel = {
    enable = true;
    profileNumber = 0;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.availableKernelModules = [ "nvme" "ahci" "usb_storage" "usbhid" ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.substituters = [ "https://cuda-maintainers.cachix.org" ];
  nix.settings.trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];

  programs.dconf.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 5000 ];
  };

  services.frigate = {
    enable = false;
    hostname = "localhost";

    settings = {
      mqtt.enabled = false;
      record = {
        enabled = true;
      };
      ffmpeg.hwaccel_args = "preset-jetson-h264";
      cameras."driveway" = {
        ffmpeg.inputs = [ {
          path = builtins.readFile config.age.secrets.driveway.path; # This is documented as bad practice, but it's the only way to get the secret into the config
          roles = [
            "record"
            "detect"
          ];
        } ];
      };
    };
  };

  users.users = {
    gdwr = {
      shell = pkgs.nushell;
      password = "gdwr";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  services.openssh.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
