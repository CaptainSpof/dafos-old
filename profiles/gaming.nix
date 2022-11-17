{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.gaming;
in {
  options.profiles.gaming = {
    enable = mkOption { type = types.bool; default = true; };
  };
  config = mkIf cfg.enable {
    environment.defaultPackages = with pkgs; [
      lutris
    ];
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
  };
}
