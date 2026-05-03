{ self, inputs, ... }: {
  flake.nixosModules.audio = { pkgs, lib, ... }: {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}