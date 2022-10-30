{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.hardware.logitech;
in {
  options.profiles.hardware.logitech = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    # Packages
    environment.systemPackages = with pkgs; [
      logiops
      piper
    ];
    services.udev.packages = [ pkgs.logitech-udev-rules ];
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE:="0660", OPTIONS+="static_node=uinput"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="input"
    '';

    # Services
    systemd.services.logid = {
      enable = true;
      description = "Logitech Configuration Daemon.";
      wantedBy = [ "graphical.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.logiops}/bin/logid -c " + ./logid.cfg;
      };
    };

  };
}
