{
  description = "GDWR's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/configuration.nix];
      };
    };

    # TODO: refactor for all architectures
    packages.x86_64-linux.krisp = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/krisp-patch { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
  };
}
