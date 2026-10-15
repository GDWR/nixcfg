{ ... }: {
  perSystem = { pkgs, ... }:
    let
      # Deletes profile generations older than <age> (any `--delete-older-than`
      # value, e.g. 30d), then garbage-collects the store. Runs once as the user
      # (home-manager, ~/.local/state/nix/profiles) and once as root (system,
      # /nix/var/nix/profiles), as neither run reaches the other's profiles.
      system-clean =
        { writeShellApplication, ... }:
        writeShellApplication {
          name = "system-clean";
          text = ''
            if [ $# -lt 1 ]; then
              echo "usage: system-clean <age> [nix-collect-garbage options]" >&2
              echo "  e.g. system-clean 30d" >&2
              exit 1
            fi
            age="$1"
            shift

            nix-collect-garbage --delete-older-than "$age" "$@"
            sudo nix-collect-garbage --delete-older-than "$age" "$@"
          '';
        };
    in
    {
      packages.system-clean = pkgs.callPackage system-clean { };
    };
}
