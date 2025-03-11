{ pkgs, ... }: {
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    memtest86.enable = true;
  };
}
