{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };
  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
}
