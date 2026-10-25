{
  description = "GDWR's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    carbon = {
      url = "git+ssh://git@github.com/owl-corp/carbon";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-parts.follows = "flake-parts";
      inputs.import-tree.follows = "import-tree";
    };
  };

  outputs = inputs: 
    inputs.flake-parts.lib.mkFlake { inherit inputs; }  {
      imports = [
        inputs.carbon.flakeModules.default
        (inputs.import-tree ./modules)
      ];
    };
}
