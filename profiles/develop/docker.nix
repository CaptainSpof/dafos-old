{ config, pkgs, ... }:

# TODO: mkOption
{
  home-manager.users."${config.vars.username}".home.packages = [ pkgs.docker-compose ];
}
