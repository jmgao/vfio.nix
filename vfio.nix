{ lib, pkgs, ... }:

let
  devices = [
    { device = "10de:1b06"; } # GPU
    { device = "10de:10ef"; } # GPU audio
    { device = "1912:0014"; } # USB controller
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
      "pcie_aspm=off"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      "kvm_amd.npt=1"
      "kvm_amd.nested=1"
      "kvm_amd.avic=1"

      "hugepagesz=1G"
      "hugepages=32"

      "isolcpus=domain,32-47,96-111"
#     "nohz_full=32-47,96-111"
      "rcu_nocbs=32-47,96-111"

      "vfio-pci.ids=${lib.concatMapStringsSep "," (d: d.device) devices}"
    ];

    kernelPatches = [
      {
        name = "vfio";
        patch = null;
        extraConfig = ''
          # Triggers an NPE in ZFS
          NO_HZ_FULL n

          KVM y
          KVM_AMD y

          VFIO y
          VFIO_IOMMU_TYPE1 y
          VFIO_VIRQFD y
          VFIO_PCI y

          DRM_NOUVEAU n
          FB_NVIDIA n
        '';
      }
    ];
  };

  services.irqbalance.enable = true;

  environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  nixpkgs.overlays = [
    ( import ./overlays/libvirt.nix )
  ];
}
