{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.graphical.chats;
in {
  options.profiles.graphical.chats = {
    enable          = mkOption { type = types.bool; default = true; };
    telegram.enable = mkOption { type = types.bool; default = true; };
    slack.enable    = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {

      home.packages = with pkgs;
        (if cfg.telegram.enable then [
          tdesktop
        ] else []) ++
        (if cfg.slack.enable then [
          slack
        ] else []);
    };
  };
}
