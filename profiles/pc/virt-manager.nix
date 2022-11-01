{ lib, config, pkgs, ... }:

with lib;
let cfg = config.profiles.virt-manager;
in {
  options.profiles.virt-manager = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
