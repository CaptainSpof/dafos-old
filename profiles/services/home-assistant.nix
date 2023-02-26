{ config, options, pkgs, lib, ... }:

with lib;
let
  cfg = config.profiles.services.home-assistant;
in {
  options.profiles.services.home-assistant = {
    enable = mkOption { type = types.bool; default = false; };
    serial = {
      port = mkOption {
        type = types.str;
        default = "/dev/ttyACM0";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mosquitto home-assistant-cli ];
    services.mosquitto = {
      enable = true;
      listeners = [{
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }];
    };
    services.zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant = config.services.home-assistant.enable;
        permit_join = true;
        mqtt = {
          server = "mqtt://127.0.0.1:1883";
          base_topic = "zigbee2mqtt";
        };
        serial = {
          port = cfg.serial.port;
          adapter = "deconz";
        };
        frontend = {
          port = 8883;
        };
        advanced = { log_level = "debug"; };
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.homeassistant = {
        volumes = [ "home-assistant:/config" ];
        environment.TZ = "Europe/Paris";
        image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--cap-add=CAP_NET_RAW,CAP_NET_BIND_SERVICE"
          "--network=host"
          "--device=${cfg.serial.port}:${cfg.serial.port}"
        ];
      };
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8123 8883 ];
    };
  };
}
