{ self, inputs, ... }: {
  flake.nixosModules.shell = { pkgs, lib, ... }: {
    programs.fish.enable = true;
    environment.pathsToLink = [
      "/share/fish"
    ];
  };
}