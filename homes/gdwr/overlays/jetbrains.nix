# https://github.com/NixOS/nixpkgs/issues/425328
{ system, ... }:
(final: prev: let 
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/08f22084e6085d19bcfb4be30d1ca76ecb96fe54.tar.gz";
    sha256 = "sha256:178b0kzs9fn4iva94a7g6zj769mxwhswmgy9i0mmprkkv0afaksw";
  }) { inherit system; };
in {
  jetbrains = nixpkgs.jetbrains;
})