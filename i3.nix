{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        xautolock
      ];
    };

    exportConfiguration = true;

    extraConfig = ''
      Section "Extensions"
        Option      "DPMS" "Disable"
      EndSection
    '';
  };
  services.compton.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    gnome3.gnome-screenshot
    google-chrome
    xclip
  ];

  fonts = {
    fonts = with pkgs; [
      powerline-fonts
    ];
  };
}
