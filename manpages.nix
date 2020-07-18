{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.manpages ];
  documentation.dev.enable = true;
}
