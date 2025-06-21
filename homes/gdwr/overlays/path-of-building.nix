{ system, ... }:
(final: prev: let
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/0feafdbc84139a414f5d46a11cf91fc4fcd85ffb.tar.gz";
    sha256 = "sha256:15lplxgcqz9bdf8qa7ri63jy7zakm7ldrmqmfmjrp37ig752rs4x";
  }) { inherit system; };
in {
  path-of-building = nixpkgs.path-of-building.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/applications/path-of-building.desktop \
        --replace "Exec=pobfrontend %U" "Exec=env WAYLAND_DISPLAY=wayland-0 pobfrontend %U"
    '';
  });
})
