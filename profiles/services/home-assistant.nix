{ config, options, pkgs, lib, ... }:

with lib;
let
  cfg = config.profiles.services.home-assistant;
in {
  options.profiles.services.home-assistant = {
    enable = mkOption { type = types.bool; default = false; };
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
          port = "/dev/ttyACM1";
          adapter = "deconz";
        };
        advanced = { log_level = "debug"; };
      };
    };
    services.home-assistant = {
      enable = true;
      package = pkgs.home-assistant;
      extraPackages = python3Packages:
        with python3Packages; [
          pyipp
          # pyforked-daapd
          aiohomekit
          spotipy
          pyatv
        ];
      extraComponents = [
        # Components required to complete the onboarding
        "freebox"
        "met"
        "mqtt"
        "radio_browser"
        "spotify"
        "tradfri"
        "wled"
        "xiaomi"
        "xiaomi_aqara"
        "xiaomi_miio"
        "yeelight"
        "zha"
      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        sensor = [{
          platform = "time_date";
          display_options = [ "date_time_iso" "date" ];
        }];
      };
    };
    # systemd.tmpfiles.rules = [
    #   "C /var/lib/hass/custom_components/sonoff - - - - ./"
    #   "Z /var/lib/hass/custom_components 770 hass hass - -"
    # ];
  };
}
