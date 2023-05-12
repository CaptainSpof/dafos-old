{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.editor.pycharm;
in {
  options.profiles.editor.pycharm = {
    enable = mkOption { type = types.bool; default = true; };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {
      home.packages = with pkgs; [
        jetbrains.pycharm-community
      ];
    };
  };
}
