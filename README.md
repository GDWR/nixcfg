# NixOS Configuration

## Quickstart
Install host: `nixos-rebuild switch --flake github:gdwr/nixcfg#desktop`
Run package: `nix run github:gdwr#krisp-patch`

## Repository Layout
```yaml
├── homes            # Use homes, utilizing home-manager (user login defined on host, TBD best way to do this)
│   └── gdwr         # Hey! Thats me. Full fat, desktop environment. 
├── hosts            # Actual system, hardware/system configurations
│   ├── desktop      # By name and by nature, x86 AMD + Nvidia GPU
│   ├── laptop       # By name and by nature, x86 Intel
│   └── xavier       # Nvidia Jetson Xaiver, ARM64 + Nvidia specialized GPU
├── packages         # Exported nix flake packages, `nix run github:gdwr/nixcfg#packageName
│   └── krisp-patch  # Patch discord krisp to navigate around DRM disabling.
└── secrets          # agenix managed secrets
```

## Resources
- [Nix Search](https://search.nixos.org)
- [HomeManager Search](https://mipmip.github.io/home-manager-option-search)
- [MatthewCroughan/nixcfg](https://github.com/MatthewCroughan/nixcfg)
