{
  description = "GDWR's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plate = {
      url = "github:gdwr/plate";
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
    };
  };
}
