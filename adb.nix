{ config, pkgs, ... }:

{
  programs.adb.enable = true;
  users.users.jmgao.extraGroups = [ "adbusers" ];
}
