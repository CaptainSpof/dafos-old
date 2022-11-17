{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.graphical.krita;
in
{
  options.profiles.graphical.krita = {
    enable = mkOption { type = types.bool; default = false; };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {
      home.packages = with pkgs; [
        krita
      ];

    };
  };
}
