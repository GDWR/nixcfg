# NixOS Configuration

apply system `sudo nixos-rebuild switch --flake .#desktop`
apply home `home-manager switch --flake .#gdwr@desktop`


## Resources

- [starter config](https://github.com/Misterio77/nix-starter-configs/tree/main) 
