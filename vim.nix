{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vim_configurable.override { python = python3; })
  ];

  environment.variables = {
    EDITOR = "vim";
  };
}
