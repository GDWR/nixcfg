{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.disko.nixosModules.disko

    ./audio.nix
    ./bootloader.nix
    ./desktopEnvironment.nix
    ./disks.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./shell.nix
  ];

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [ "root" "gdwr" ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "laptop";

  boot.tmp.cleanOnBoot = true;

  users.users = {
    gdwr = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" "gamemode" "libvirtd" ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
