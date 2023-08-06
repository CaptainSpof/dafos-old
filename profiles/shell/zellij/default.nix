{ config, lib, ... }:

with lib;
let cfg = config.profiles.shell.zellij;
in {
  options.profiles.shell.zellij = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {
      programs.zellij = {
        enable = true;
        enableFishIntegration = false;
      };
      home.file.".config/zellij" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
