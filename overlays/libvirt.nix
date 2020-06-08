self: super:
{
  libvirt = super.libvirt.overrideAttrs (old: rec {
    name = "libvirt-${version}";
    version = "6.4.0";
    src = super.fetchgit {
      url = "git://libvirt.org/libvirt.git";
      rev = "v${version}";
      sha256 = "12jbm3absy4i0wmd22n6cy9ws43rqphzzrp75lnbgsp7spd2qaxk";
      fetchSubmodules = true;
    };
    patches = [ ./amd-stibp.patch ];
  }
);

  qemu = super.qemu.overrideAttrs (old: rec {
    name = "qemu-${version}";
    version = "5.0.0";
    src = super.fetchurl {
      url = "https://wiki.qemu.org/download/qemu-${version}.tar.bz2";
      sha256 = "1ysyax70ljih46b87fd6rvrm1y0vvkmnmylr2qpgd2kf18fzhs63";
    };
    patches = super.lib.sublist 0 1 old.patches;
  });
}
