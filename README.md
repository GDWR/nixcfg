# NixOS Configuration

## Systems

### Desktop

`sudo nixos-rebuild switch --flake .#desktop`

## Flakes

### krisp-patch
Patch the latest version of Discord to enable krisp. \
`nix run github:gdwr/flakes#krisp-patch`

https://github.com/NixOS/nixpkgs/issues/195512


## Resources
- [Nix Search](https://search.nixos.org)
- [HomeManager Search](https://mipmip.github.io/home-manager-option-search)
