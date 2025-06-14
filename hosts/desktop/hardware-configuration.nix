# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  services.xserver.videoDrivers = ["nvidia" "modesetting"];
  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      prime = {
        reverseSync.enable = true;
        offload.enableOffloadCmd = true;

        amdgpuBusId = "PCI:16:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics ={
      enable = true;
      enable32Bit = true;
    };
  };
}
