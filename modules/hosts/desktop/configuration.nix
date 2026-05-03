{ self, inputs, ... }: {

  flake.nixosModules.desktopConfiguration = { pkgs, lib, ... }: {
    # import any other modules from here
    imports = [
      self.nixosModules.desktopHardware
      self.nixosModules.audio
      self.nixosModules.bootloader
      self.nixosModules.gaming
      self.nixosModules.shell
      self.nixosModules.virtualisation
    ];

    programs.gnupg.agent.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = false;
    };

    environment.systemPackages = with pkgs; [
      kitty
      rofi
      waybar
      hyprpaper
      hyprpicker
      hyprshot
      hyprlock
      wl-clipboard
    ];

    services.displayManager.defaultSession = "hyprland";
    services.displayManager.gdm.enable = true;
    services.xserver.enable = true;


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