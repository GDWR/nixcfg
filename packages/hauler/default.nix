{ pkgs, system, ... }:
let
  cosign = pkgs.callPackage ./cosign.nix { inherit pkgs; };
  arch = if system == "x86_64-linux" then "amd64" else "arm64";
in
pkgs.buildGoModule rec {
  pname = "hauler";
  version = "1.0.8";

  src = pkgs.fetchFromGitHub {
    owner = "hauler-dev";
    repo = "hauler";
    rev = "v${version}";
    hash = "sha256-el6j6ZPpVxv1ma3DVxnBleG8CeN3fiTDCbNFS2fkHxo=";
  };

  vendorHash = "sha256-JZ/H2uKTO90SZumoUNlFam1xobnPnKWF5OJj7JlhWls=";

  preBuild = ''
    mkdir -p cmd/hauler/binaries
    cp ${cosign}/bin/cosign cmd/hauler/binaries/cosign-linux-${arch}
  '';

  preCheck = ''
    rm pkg/collection/imagetxt/imagetxt_test.go # Require network access
    rm pkg/content/chart/chart_test.go # Require network access
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/hauler-dev/hauler";
    description = "Airgap Container Swiss Army Knife";
    changelog = "https://github.com/hauler-dev/hauler/releases/tag/v${version}";
    license = licenses.asl20;
  };
}
