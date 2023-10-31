{ pkgs, ... }: 
  pkgs.stdenv.mkDerivation {
    name = "krisp-patch";
    version = "0.0.1";
    src = ./.;
    buildInputs = [ pkgs.rizin pkgs.ripgrep];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/krisp-patch $out/bin/krisp-patch
      chmod +x $out/bin/krisp-patch
    '';

    postFixup = ''
      wrapProgram $out/bin/krisp-patch --set PATH ${ pkgs.lib.makeBinPath [
        pkgs.coreutils
        pkgs.ripgrep
        pkgs.rizin
        ]}
    '';
  }