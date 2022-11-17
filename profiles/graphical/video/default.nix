{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.graphical.video;
in
{
  options.profiles.graphical.video = {
    enable = mkOption { type = types.bool; default = true; };
    kdenlive.enable = mkOption { type = types.bool; default = false; };
    mpv.enable = mkOption { type = types.bool; default = false; };
    mpv.celluloid.enable = mkOption { type = types.bool; default = false; };
    recording.enable = mkOption { type = types.bool; default = false; };
    vlc.enable = mkOption { type = types.bool; default = true; };
    youtube-dl.enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {

    home-manager.users."${config.vars.username}" = {

      home.packages = with pkgs;
      (if cfg.mpv.enable then [
        mpv-with-scripts
        mpvc
        (mkIf cfg.mpv.celluloid.enable
          celluloid)  # nice GTK GUI for mpv
      ] else []) ++
      [
        (mkIf cfg.kdenlive.enable kdenlive)
        (mkIf cfg.recording.enable obs-studio)
        (mkIf cfg.vlc.enable vlc)
        (mkIf cfg.youtube-dl.enable youtubeDL)
        ffmpeg
      ];

    };
  };

}
