{ appimageTools, fetchurl, ... }:
let
  pname = "zen";
  version = "1.9.1b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/1.9.1b/zen-x86_64.AppImage";
    sha256 = "sha256-OpdUeFzFAWi1ur2nKt4WSWJqj/J/4iigSmxMBCOGg+w=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    ffmpeg
  ];
  extraInstallCommands = ''
    # Install .desktop file
    install -m 444 -D ${appimageContents}/zen.desktop $out/share/applications/${pname}.desktop
    # Install icon
    install -m 444 -D ${appimageContents}/zen.png $out/share/icons/hicolor/128x128/apps/${pname}.png
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
  };
}
