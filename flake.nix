{
  description = "GDWR's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ]
        (system: function nixpkgs.legacyPackages.${system});
    in {

      homeConfigurations = {
        gdwr = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # This should be inherited from the caller machine?
          extraSpecialArgs = { inherit inputs; };
          modules = [ 
            ./homes/gdwr
          ];
        };
      };

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/desktop ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/laptop ];
        };
      };

      packages = forAllSystems (pkgs: {
        krisp-patch = pkgs.callPackage ./packages/krisp-patch { inherit pkgs; };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
