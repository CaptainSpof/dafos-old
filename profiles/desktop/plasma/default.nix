{ config, lib, pkgs, ... }:

{

    services = {
      xserver = {
        enable = true;
        displayManager = {
          sddm = {
            enable = true;
            # theme = "${pkgs.my.chili}/share/sddm/themes/chili";
            # For some reason, the derivation is weird on my display, this fixes it.
            theme = "${(pkgs.fetchFromGitHub {
              owner = "MarianArlt";
              repo = "kde-plasma-chili";
              rev = "a371123959676f608f01421398f7400a2f01ae06";
              sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
            })}";
            settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
          };
        };
        desktopManager.plasma5.enable = true;
        desktopManager.plasma5.runUsingSystemd = true;
      };
    };

}
