{ pkgs, ... }: {
  nixpkgs.overlays = [(import ./overlays/path-of-building.nix { system = pkgs.stdenv.hostPlatform.system; })];

  home.packages =  with pkgs; [
    path-of-building

    (callPackage ./packages/awakened-poe-trade {})
  ];
}
