{ appimageTools, fetchurl, ... }:
let
  pname = "awakened-poe-trade";
  version = "3.27.103";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v3.27.103/Awakened-PoE-Trade-3.27.103.AppImage";
    sha256 = "sha256-WCuwriNN3roK5heu+CdYZ7AHif4s3cZjTfHGIXXXkuQ=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/awakened-poe-trade.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/awakened-poe-trade.desktop \
      --replace "Exec=AppRun --sandbox %U" "Exec=awakened-poe-trade %U"

    install -m 444 -D ${appimageContents}/awakened-poe-trade.png $out/share/icons/hicolor/128x128/apps/${pname}.png
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
  };
}
