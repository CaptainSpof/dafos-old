{ config, ... }:

{
  services.tailscale.enable = false;

  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose"; # for Tailscale
  };
}
