{ pkgs, ... }: {
  programs.steam.enable = true;
  programs.steam.protontricks.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];

  programs.gamemode.enable = true;
  programs.gamemode.settings.general.inhibit_screensaver = 0;

  environment.systemPackages = with pkgs; [
    bottles
    mangohud
  ];
}