{ config, pkgs, ... }:

{
  # REVIEW: useful with plasma?
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
    extraConfig = ''
      HandlePowerKey=lock
      LidSwitchIgnoreInhibited=no
    '';
  };
  services.power-profiles-daemon.enable = true;
  powerManagement.powertop.enable = true;

  # REVIEW
  # Reload ddcci module on monitor hotplug
  # services.udev.extraRules =
  #   let
  #     reloadScript = pkgs.writeShellScriptBin "reload-ddcci" ''
  #       ${pkgs.kmod}/bin/modprobe -r ddcci && ${pkgs.kmod}/bin/modprobe ddcci
  #     '';
  #   in
  #   ''
  #     KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="change", RUN+="${reloadScript}/bin/reload-ddcci"
  #   '';

  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [ powertop ];
  };
}
