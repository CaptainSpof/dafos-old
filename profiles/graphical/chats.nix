{ config, pkgs, ... }:

{
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [ tdesktop slack ];
  };
}
