{ lib, pkgs, ... }:

let
  devices = [
    { device = "10de:1b06"; } # GPU
    { device = "10de:10ef"; } # GPU audio
    { device = "1912:0014"; } # USB controller
    { device = "1987:5012"; } # SSD
  ];
in {
  fileSystems."/dev/hugepages1G" = {
    device = "hugetlbfs";
    fsType = "hugetlbfs";
    options = [
      "pagesize=1048576k"
    ];
  };

  boot = {
    kernelParams = [
      "quiet"

      "mitigations=off"

      "amd_iommu=on"
      "iommu=pt"
      "pcie_aspm=off"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      "kvm_amd.npt=1"
      "kvm_amd.nested=1"
      "kvm_amd.avic=1"

      "transparent_hugepage=never"
      "hugepagesz=1G"
      "hugepages=32"

      "isolcpus=domain,wq,rcu,32-47,96-111"
      "nohz_full=32-47,96-111"
      "vfio-pci.ids=${lib.concatMapStringsSep "," (d: d.device) devices}"
    ];

    kernelPatches = [
      {
        name = "vfio";
        patch = null;
        extraConfig = ''
          ## Tuning
          CPU_ISOLATION y

          RCU_EXPERT y
          RCU_NOCB_CPU y

          # Triggers oops in ZFS.
          NO_HZ_FULL n

          ## VFIO requirements
          KVM y
          KVM_AMD y

          VFIO y
          VFIO_IOMMU_TYPE1 y
          VFIO_VIRQFD y
          VFIO_PCI y
        '';
      }
      {
        name = "kthreadd_affinity";
        patch = ./patches/kthreadd_affinity.patch;
      }
    ];

    kernel.sysctl = {
      "vm.stat_interval" = 300;
    };
  };

  services.irqbalance.enable = true;

  environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "start";
    onShutdown = "shutdown";
  };

  users.users.jmgao.extraGroups = [ "libvirtd" ];

  environment.systemPackages = [
    pkgs.looking-glass-client
    pkgs.virt-manager
  ];

  nixpkgs.overlays = [
    ( import ./overlays/libvirt.nix )
    ( import ./overlays/looking-glass-client.nix )
  ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 jmgao qemu-libvirtd -"
  ];
}
