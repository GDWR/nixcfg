{ ... }: {
  perSystem = { pkgs, self', ... }:
    let
      # Runs every package's update.sh and updates flake.lock, then hands off to
      # system-rebuild to switch the NixOS system and home-manager configs. Works
      # on the checkout rather than the store copy of this flake, as the updates
      # write back into it.
      system-update =
        { writeShellApplication, system-rebuild, ... }:
        writeShellApplication {
          name = "system-update";
          runtimeInputs = [ system-rebuild ];
          text = ''
            cd "''${NIXCFG:-$HOME/Repos/nixcfg}"

            shopt -s nullglob
            for script in modules/packages/*/update.sh; do
              echo "==> $script"
              "$script"
            done

            nix flake update

            system-rebuild
          '';
        };
    in
    {
      packages.system-update = pkgs.callPackage system-update {
        inherit (self'.packages) system-rebuild;
      };
    };
}
