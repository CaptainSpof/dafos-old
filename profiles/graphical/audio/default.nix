{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.graphical.audio;
in
{
  options.profiles.graphical.audio = {
    enable = mkOption { type = types.bool; default = true; };
    spotify.enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    home-manager.users."${config.vars.username}" = {
      home.packages = with pkgs;
        [
          (mkIf cfg.spotify.enable spotify)

          (mkIf cfg.spotify.enable (makeDesktopItem {
            name = "spotify-hidpi";
            desktopName = "Spotify HiDPI";
            genericName = "Spotify but scaled for hidpi screens";
            icon = "spotify-client";
            exec = "${spotify}/bin/spotify --force-device-scale-factor=1.5 %U";
            categories = [ "Audio" "Music" "Player" "AudioVideo" ];
          }))
        ];
    };
  };

}
