{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;

    videoDrivers = ["amdgpu"];

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
        redshift
        xautolock
      ];
    };

    exportConfiguration = true;

    monitorSection = ''
      Option "DPMS" "false"
      Modeline "3440x1440_100"  531.52  3440 3448 3480 3520  1440 1496 1504 1510 +hsync -vsync
      Option "PreferredMode" "3440x1440_100"
    '';

    extraConfig = ''
      Section "Extensions"
        Option      "DPMS" "Disable"
      EndSection
    '';
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

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
