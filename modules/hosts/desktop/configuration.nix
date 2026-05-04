{ self, inputs, ... }: {

  flake.nixosModules.desktopConfiguration = { pkgs, lib, ... }: {
    # import any other modules from here
    imports = [
      self.nixosModules.desktopHardware
      self.nixosModules.audio
      self.nixosModules.gaming
      self.nixosModules.hyprland
      self.nixosModules.waybar
      self.nixosModules.shell
      self.nixosModules.virtualisation
    ];

    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      memtest86.enable = true;
    };

    gdwr.hyprland.monitors = [
      "DP-4, 2560x1440@165, auto-left, 1"
      "DP-5, 2560x1440@165, auto-right, 1"
    ];

    programs.gnupg.agent.enable = true;

    services.gnome.gnome-keyring.enable = true;


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
  };
}