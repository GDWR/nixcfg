{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    optimise.automatic = true;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [ "root" "gdwr" ];
    };
  };


  networking.hostName = "desktop";
  systemd.targets.hibernate.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.tmp.cleanOnBoot = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  programs.nix-ld.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.nh.enable = true;
  programs.fish.enable = true;
  users.users = {
    gdwr = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" ];
    };
  };

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "gnome";
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    desktopManager = {
      gnome.enable = true;
    };
    videoDrivers = [ "nvidia" ];
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

  environment.systemPackages = [
    pkgs.pinentry
    pkgs.stdenv.cc.cc
  ];

  # Exclude Default Gnome Apps
  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab # disk usage analyzer
    cheese # photo booth
    eog # image viewer
    epiphany # web browser
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
    geary # email client

    # these should be self explanatory
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-screenshot
    gnome-system-monitor
    gnome-weather
    gnome-disk-utility
    pkgs.gnome-connections
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
