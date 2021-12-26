{ config, lib, pkgs, ... }:

{
  networking.hosts = {
    "192.168.0.29" = [ "dafphone" ];
    "192.168.0.30" = [ "daftop" ];
    "192.168.0.31" = [ "dafbox" ];
    "192.168.0.33" = [ "dafpi" ];
    "192.168.0.35" = [ "dafpihole" ];
    "127.0.0.1" = [ "sync.daf" "pihole.daf" ];
  };
}
