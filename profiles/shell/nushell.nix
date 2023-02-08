{ config, lib, pkgs, ... }:

{
  home-manager.users."${config.vars.username}" = {
    programs.nushell = {
      enable = true;
    };
  };
}
