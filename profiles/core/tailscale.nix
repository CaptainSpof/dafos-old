{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.tailscale;
in {
  options.profiles.tailscale = {
    enable = mkOption { type = types.bool; default = false; };
  };
  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose"; # for Tailscale
    };
  };
}
