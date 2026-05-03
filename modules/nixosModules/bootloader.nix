{ self, inputs, ... }: {
  flake.nixosModules.bootloader = { pkgs, lib, ... }: {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      memtest86.enable = true;
    };
  };
}