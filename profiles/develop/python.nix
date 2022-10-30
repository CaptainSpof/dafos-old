{ lib, config, pkgs, ... }:

with lib;
let cfg = config.profiles.develop.python;
in {
  options.profiles.develop.python = {
    enable = mkOption { type = types.bool; default = false; };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {
      home.packages = with pkgs.python39Packages; [ virtualenv poetry ptpython invoke ];
    };
  };
}
