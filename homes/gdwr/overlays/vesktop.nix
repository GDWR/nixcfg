{ pkgs, ... }:
(final: prev: {
  vesktop = prev.vesktop.overrideAttrs (oldAttrs: rec {
    desktopItems = pkgs.makeDesktopItem {
        name = "vesktop";
        desktopName = "Vesktop";
        exec = "vesktop %U --disable-gpu";
        icon = "vesktop";
        startupWMClass = "Vesktop";
        genericName = "Internet Messenger";
        keywords = [
          "discord"
          "vencord"
          "electron"
          "chat"
        ];
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
    };
  });
})
