{ config, pkgs, ... }:

{
  services.udev.packages = [ pkgs.libu2f-host ];
}
