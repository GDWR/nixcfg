{ self, inputs, ... }: {
  flake.nixosModules.waybar = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.waybar ];

    environment.etc."xdg/waybar/config".source = ./config;
    environment.etc."xdg/waybar/style.css".source = ./style.css;
  };
}
