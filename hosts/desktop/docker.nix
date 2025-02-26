{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };
  hardware.nvidia-container-toolkit.enable = true;
}
