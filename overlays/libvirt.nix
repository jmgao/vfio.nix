self: super:
{
  libvirt = super.libvirt.overrideAttrs (old: rec {
    patches = [ ./amd-stibp.patch ];
  });
}
