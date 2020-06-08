self: super:
{
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    name = "libvirt-${version}";
    version = "B2-rc2-9";
    buildInputs = old.buildInputs ++ [
      super.pkgs.expat
      super.pkgs.xorg.libXi
    ];
    src = super.fetchgit {
      url = "git://github.com/gnif/LookingGlass";
      rev = "ede96fa4868bc646c6230d948d11cf1a7b1f1179";
      sha256 = "0r9bvfm1sj8in11cyi50g5k4pmm8ladlkmfm7674w8gck20aj7xb";
      fetchSubmodules = true;
    };

    sourceRoot = "LookingGlass-ede96fa/client";
  });
}
