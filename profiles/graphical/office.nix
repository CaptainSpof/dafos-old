{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.graphical.office;
in
{
  options.profiles.graphical.office = {
    enable = mkOption { type = types.bool; default = true; };
    libreoffice.enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    home-manager.users."${config.vars.username}" = {

      home.packages = with pkgs;
        (if cfg.libreoffice.enable then [
          libreoffice-fresh
        ] else [ ]);
    };
  };
}
