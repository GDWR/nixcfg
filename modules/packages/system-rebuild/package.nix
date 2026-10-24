{ ... }: {
  perSystem = { pkgs, ... }:
    let
      # Switches the NixOS system and home-manager configs to the local checkout
      # as-is, without running update scripts or touching flake.lock.
      system-rebuild =
        { writeShellApplication, nix-output-monitor, ... }:
        writeShellApplication {
          name = "system-rebuild";
          runtimeInputs = [ nix-output-monitor ];
          text = ''
            cd "''${NIXCFG:-$HOME/Repos/nixcfg}"

            # Prompt for the password now, before nom takes over the terminal.
            sudo -v
            sudo nixos-rebuild switch --flake . --log-format internal-json -v |& nom --json
            home-manager switch --flake . --log-format internal-json -v |& nom --json
          '';
        };
    in
    {
      packages.system-rebuild = pkgs.callPackage system-rebuild { };
    };
}
