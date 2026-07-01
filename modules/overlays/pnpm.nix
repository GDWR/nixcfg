{ ... }: {
  # vesktop pins `pnpm_10_29_2` as a build dependency, but that exact version
  # is currently flagged insecure upstream (CVE-2026-48995 and others), which
  # blocks evaluation. Override it to the latest patched pnpm 10 release.
  # See https://github.com/NixOS/nixpkgs/issues/536623
  flake.overlays.pnpm-insecure = final: _prev: {
    pnpm_10_29_2 = final.pnpm_10;
  };
}
