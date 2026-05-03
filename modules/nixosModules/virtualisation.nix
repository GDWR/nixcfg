{ self, inputs, ... }: {
  flake.nixosModules.virtualisation = { pkgs, lib, ... }: {
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
    };

    environment.systemPackages = with pkgs; [
      virt-manager
    ];
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
}