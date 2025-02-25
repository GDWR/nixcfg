{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default

    ./bootloader.nix
    ./docker.nix
    ./hardware-configuration.nix
    ./shell.nix
    ./steam.nix
  ];

  nix = {
    optimise.automatic = true;

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
      extraGroups = [ "docker" "wheel" "gamemode" ];
    };
  };

  services.displayManager.defaultSession = "gnome";
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager = {
      gnome.enable = true;
    };
    videoDrivers = [ "nvidia" "amdgpu" ];
    excludePackages = [ pkgs.xterm ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = [
    pkgs.pinentry
    pkgs.stdenv.cc.cc
  ];

  # Exclude Default Gnome Apps
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.baobab      # disk usage analyzer
    pkgs.cheese      # photo booth
    pkgs.eog         # image viewer
    pkgs.epiphany    # web browser
    pkgs.simple-scan # document scanner
    pkgs.totem       # video player
    pkgs.yelp        # help viewer
    pkgs.evince      # document viewer

    # these should be self explanatory
    pkgs.gnome-calculator
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-screenshot
    pkgs.gnome-system-monitor
    pkgs.gnome-weather
    pkgs.gnome-connections
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
