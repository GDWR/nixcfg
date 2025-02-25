{ pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];
}