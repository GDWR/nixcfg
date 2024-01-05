{
  description = "GDWR's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./nixos/configuration.nix];
      };
    };

    packages = {
      x86_64-linux.krisp-patch = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/krisp-patch { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
      aarch64-linux.krisp-patch = nixpkgs.legacyPackages.aarch64-linux.callPackage ./packages/krisp-patch { pkgs = nixpkgs.legacyPackages.aarch64-linux; };
      x86_64-linux.spacetimedb = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/spacetimedb { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
      aarch64-linux.spacetimedb = nixpkgs.legacyPackages.aarch64-linux.callPackage ./packages/spacetimedb { pkgs = nixpkgs.legacyPackages.aarch64-linux; };
    };

    apps = {
      x86_64-linux.spacetimedb = {
        type = "app";
        program = "${self.packages.x86_64-linux.spacetimedb}/bin/spacetime";
      };
      aarch64-linux.spacetimedb = {
        type = "app";
        program = "${self.packages.aarch64-linux.spacetimedb}/bin/spacetime";
      };
    };
  };
}
