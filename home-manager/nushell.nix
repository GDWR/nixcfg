# Nushell set as default in nixos/configuration.nix
{ ... }: {
  programs.nushell.enable = true;

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}