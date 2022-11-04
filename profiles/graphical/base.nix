{ config, pkgs, ... }:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "ddcci" ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    ibm-plex
    iosevka-comfy.comfy
    iosevka-comfy.comfy-duo
    iosevka-comfy.comfy-wide
    iosevka-comfy.comfy-wide-duo
    iosevka-comfy.comfy-wide-fixed
    iosevka-comfy.comfy-fixed
    iosevka-comfy.comfy-motion
    iosevka-comfy.comfy-motion-duo
    iosevka-comfy.comfy-motion-fixed
    font-awesome
    twitter-color-emoji
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Inconsolata" "Iosevka" ]; })
  ];

  programs.light.enable = true;
  programs.kdeconnect.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
    };
  };
}
