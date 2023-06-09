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

    boot.kernelModules =  [ (mkIf cfg.recording.enable "v4l2loopback")];
    boot.extraModulePackages = [
      (mkIf cfg.recording.enable config.boot.kernelPackages.v4l2loopback)
    ];

    home-manager.users."${config.vars.username}" = {

      home.packages = with pkgs;
      (if cfg.mpv.enable then [
        mpv
        mpvc
        (mkIf cfg.mpv.celluloid.enable
          celluloid)  # nice GTK GUI for mpv
      ] else []) ++
      [
        (mkIf cfg.kdenlive.enable kdenlive)
        (mkIf cfg.recording.enable obs-studio)
        (mkIf cfg.vlc.enable vlc)
        (mkIf cfg.youtube-dl.enable yt-dlp)
        ffmpeg
      ];

    };
  };

}
