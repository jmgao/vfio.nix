{ config, pkgs, lib, ... }:

rec {
  imports = [
    ./hardware-configuration.nix

    ./adb.nix
    ./audio.nix
    ./docker.nix
    ./i3.nix
    ./manpages.nix
    ./u2f.nix
    ./vfio.nix
    ./vim.nix
  ];

  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  environment.variables.NIX_PATH = lib.concatStringsSep ":" nix.nixPath;

  environment.ld-linux = true;

  nixpkgs.config.allowUnfree = true;

  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_5_9;

  networking.hostName = "atlas";
  networking.hostId = "ea12844d";

  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  networking.bridges.br0.interfaces = [ "enp70s0" ];
  networking.interfaces.br0.useDHCP = true;
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-ip6tables" = 0;
    "net.bridge.bridge-nf-call-iptables" = 0;
    "net.bridge.bridge-nf-call-arptables" = 0;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  services.sshd.enable = true;
  programs.mosh.enable = true;

  environment.systemPackages = with pkgs; [
    htop
    (hwloc.override { x11Support = true; })
    lm_sensors
    lshw
    numactl
    nvme-cli
    pciutils
    usbutils
    boot.kernelPackages.turbostat

    killall
    reptyr
    ripgrep
    tmux

    git
    unzip
    wget

    python python3
    rustup
    scala

    autoconf
    bison
    binutils
    cmake
    dfu-util
    flex
    gcc
    gdb
    gnumake
    ninja
    pkg-config
    strace
    bash

    wine
    blender
    unityhub
  ];

  programs.zsh.enable = true;
  virtualisation.lxd.enable = true;

  users.users.jmgao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "systemd-journal" "lxd" "dialout" ];
    shell = pkgs.zsh;
  };
  services.udev.packages = [ pkgs.openocd pkgs.stlink ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="214c", MODE:="666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="214d", MODE:="666"
  '';

  system.stateVersion = "20.03";
}
