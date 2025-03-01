{ pkgs, ... }: {
  programs.firefox.enable = true;
  home.packages = with pkgs; [
    (callPackage ./packages/zen.nix {})
  ];
}
