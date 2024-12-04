{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    optimise.automatic = true;
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = [ "root" "gdwr" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "laptop";
  services.openssh.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  virtualisation.docker.enable = true;
  
  programs.fish.enable = true;
  users.users = {
    gdwr = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" "dialout" ];
    };
  };

  environment.systemPackages = with pkgs; [
    cura # 3d printing software
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ]; # Exclude xterm application
  };

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
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-font-viewer
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-screenshot
    pkgs.gnome-system-monitor
    pkgs.gnome-weather
    pkgs.gnome-disk-utility
    pkgs.gnome-connections
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
