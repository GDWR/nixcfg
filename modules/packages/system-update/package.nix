{ ... }: {
  perSystem = { pkgs, ... }:
    let
      # Runs every package's update.sh, updates flake.lock, then switches the
      # NixOS system and home-manager configs. Works on the checkout rather than
      # the store copy of this flake, as the updates write back into it.
      system-update =
        { writeShellApplication, nix-output-monitor, ... }:
        writeShellApplication {
          name = "system-update";
          runtimeInputs = [ nix-output-monitor ];
          text = ''
            cd "''${NIXCFG:-$HOME/Repos/nixcfg}"

            shopt -s nullglob
            for script in modules/packages/*/update.sh; do
              echo "==> $script"
              "$script"
            done

            nix flake update

            # Prompt for the password now, before nom takes over the terminal.
            sudo -v
            sudo nixos-rebuild switch --flake . --log-format internal-json -v |& nom --json
            home-manager switch --flake . --log-format internal-json -v |& nom --json
          '';
        };
    in
    {
      packages.system-update = pkgs.callPackage system-update { };
    };
}
