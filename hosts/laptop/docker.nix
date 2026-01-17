{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
}
