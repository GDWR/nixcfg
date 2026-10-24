{ self, inputs, ... }: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.audio
      self.nixosModules.gaming
      self.nixosModules.hyprland
      self.nixosModules.waybar
      self.nixosModules.shell
      self.nixosModules.virtualisation
      self.nixosModules.desktopHardware

      ({ pkgs, ... }: {
        boot.loader.systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };

        gdwr.hyprland.monitors = [
          "desc:Microstep MSI G27CQ4 0x000000C4, 2560x1440@165, auto-left, 1"
          "desc:Microstep MAG274QRF-QD CA8A393900098, 2560x1440@165, auto-right, 1"
        ];

        programs.gnupg.agent.enable = true;

        services.gnome.gnome-keyring.enable = true;


        nix = {
          optimise.automatic = false;
          gc.automatic = false;
          settings = {
            experimental-features = ["nix-command" "flakes"];
            auto-optimise-store = true;
            trusted-users = [ "root" "gdwr" ];
          };
        };
        nixpkgs.config.allowUnfree = true;

        networking.hostName = "desktop";

        environment.systemPackages = with pkgs; [
          self.packages.${stdenv.hostPlatform.system}.system-update
          self.packages.${stdenv.hostPlatform.system}.system-rebuild
          self.packages.${stdenv.hostPlatform.system}.system-clean
        ];

        boot.tmp.cleanOnBoot = true;

        users.users = {
          gdwr = {
            shell = pkgs.fish;
            isNormalUser = true;
            extraGroups = [ "docker" "wheel" "gamemode" "libvirtd" ];
          };
        };

        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = with pkgs; [
          icu
        ];
        services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

        services.mullvad-vpn = {
          enable = true;
          gui.enable = true;
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "23.05";
      })
    ];
  };
}
