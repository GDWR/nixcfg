{  inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    optimise.automatic = true;

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      trusted-users = ["root" "gdwr"];
    };
  };

  networking.hostName = "desktop";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  programs.nix-ld.enable = true;
  
  users.users = {
    gdwr = {
      shell = pkgs.nushell;
      isNormalUser = true;
      extraGroups = ["docker" "wheel"];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      gdwr = import ../../home-manager/home.nix;
    };
  };

  age.identityPaths = [ "/home/gdwr/.ssh/id_rsa" ];
  age.secrets.gdwr = {
    file = ../../secrets/gdwr.age;
    path = "/etc/secrets/gdwr";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = ["nvidia"];
    excludePackages = [ pkgs.xterm ]; # Exclude xterm application
  };

  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  environment.systemPackages = [
    pkgs.pinentry
    pkgs.stdenv.cc.cc
    inputs.agenix.packages.x86_64-linux.default
  ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
    ];
  };

  # Exclude Default Gnome Apps
  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    geary       # email client
  
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

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerdfonts
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
