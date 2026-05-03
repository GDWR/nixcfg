{ self, inputs, ... }: {
  flake.nixosModules.desktopHardware = { config, lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = true;
    hardware.nvidia-container-toolkit.enable = true;

    boot.initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/ce492d7d-a3ae-40f8-a66d-f0e8a6d096bf";
      fsType = "ext4";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/B40A-A732";
      fsType = "vfat";
    };
    fileSystems."/games" = {
      device = "/dev/disk/by-uuid/d78a7752-4fe8-4b4a-8d99-1df181591680";
      fsType = "ext4";
    };
    swapDevices = [ ];

    services.xserver.videoDrivers = ["nvidia" "amdgpu" "modesetting"];
    hardware = {
      cpu.amd.updateMicrocode = true;
      nvidia = {
        open = true;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          amdgpuBusId = "PCI:16:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
      graphics ={
        enable = true;
        enable32Bit = true;
      };
    };
  };
}