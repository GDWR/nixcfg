{ system, ... }:
(final: prev: {
  path-of-building = prev.path-of-building.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/applications/path-of-building.desktop \
        --replace "Exec=pobfrontend %U" "Exec=env WAYLAND_DISPLAY=wayland-0 pobfrontend %U"
    '';
  });
})