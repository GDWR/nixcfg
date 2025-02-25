{ pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
}