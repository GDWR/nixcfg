{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./audio.nix
    ./bootloader.nix
    ./desktopEnvironment.nix
    ./disks.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./shell.nix
    ./steam.nix
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

  networking.hostName = "desktop";

  boot.tmp.cleanOnBoot = true;

  users.users = {
    gdwr = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" "gamemode" "libvirtd" ];
    };
  };

  programs.nix-ld.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
