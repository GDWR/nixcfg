{ pkgs, ... }: {
  home.packages =  with pkgs; [
    path-of-building

    (callPackage ./packages/awakened-poe-trade {})
  ];
}
