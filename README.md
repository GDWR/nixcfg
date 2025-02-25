GDWR's Nix Flake
================

Quickstart
----------
See flake outputs: `nix flake show github:gdwr/nixcfg` \
Install host: `nixos-rebuild switch --flake github:gdwr/nixcfg#desktop` \
Run package: `nix run github:gdwr#krisp-patch`

Repository Layout
-----------------
```yaml
├── assets           # Data files uses within configurations or repository
├── homes            # Elementary, my dear Watson. Homes utilizing home-manager
│   └── gdwr         # Hey! Thats me. Full fat, desktop environment. 
├── hosts            # Actual systems, hardware/system configurations
│   ├── desktop      # By name and by nature, x86 AMD + Nvidia GPU
│   └── laptop       # By name and by nature, x86 Intel
└── secrets          # agenix managed secrets
```

Resources
---------
- [Nix Search](https://search.nixos.org)
- [HomeManager Search](https://mipmip.github.io/home-manager-option-search)
- [MatthewCroughan/nixcfg](https://github.com/MatthewCroughan/nixcfg)
