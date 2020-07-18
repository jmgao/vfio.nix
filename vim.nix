{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (neovim.override { vimAlias = true; })
  ];

  environment.variables = {
    EDITOR = "vim";
  };
}
