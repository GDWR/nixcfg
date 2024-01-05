{ pkgs, lib, ... }: 

    pkgs.rustPlatform.buildRustPackage rec {
        pname = "SpacetimeDB";
        version = "v0.8-beta-hotfix1";

        buildInputs = [ pkgs.openssl pkgs.openssl.dev ];
        nativeBuildInputs = [ pkgs.pkg-config pkgs.gnumake pkgs.cmake pkgs.perl ];

        src = pkgs.fetchFromGitHub {
            owner = "clockworklabs";
            repo = "SpacetimeDB";
            rev = "v0.8-beta-hotfix1";
            sha256 = "sha256-e5LinDge5lcvI4W2xsJajI3SjUahhJP4J0XNEueZlQ0=";
        };

        cargoSha256 = "sha256-bqextNzL3XJXkP/WFvlM3Kc5stOWSQDJdM01iMllXG8=";
    }
