# Yes.... I know...
{ system, ... }:
(final: prev: let
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/6e279e44c260b761bdaff782927a88f5fc272c70.tar.gz";
    sha256 = "sha256:09vax83dj096jf8kx3pmldi54ly37lkndf7i835mwpyil16hqxwg";
  }) { inherit system; };
in {
  dotnetCorePackages = prev.dotnetCorePackages // {
    sdk_5_0 = nixpkgs.dotnetCorePackages.sdk_5_0;
  };
})