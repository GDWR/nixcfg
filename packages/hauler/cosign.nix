{ pkgs, ... }:
pkgs.buildGoModule rec {
  pname = "cosign";
  version = "2.2.3+carbide.2";

  src = pkgs.fetchFromGitHub {
    owner = "hauler-dev";
    repo = "cosign";
    rev = "v${version}";
    hash = "sha256-LWvVxPTfUF5TVDAbWI/ruc7VtxONAwrS1DyMfdup8zg=";
  };

  vendorHash = "sha256-udMnSdXBjlDQlQRzhhLBDBcHwREkEev0uLIVjT8BbuU=";

  preCheck = ''
    rm pkg/blob/load_test.go # Require filesystem
    rm pkg/cosign/ctlog_test.go # Require filesystem
    rm pkg/cosign/tlog_test.go # Require filesystem
  '';

  meta = with pkgs.lib; {
    description = "Hauler fork with additional contributions";
    homepage = "https://github.com/hauler-dev/cosign";
  };
}
