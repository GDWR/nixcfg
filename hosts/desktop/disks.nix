{ pkgs, ... }: {
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
}

