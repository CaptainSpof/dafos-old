{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.hardware.audio;
in {
  options.profiles.hardware.audio = {
    pipewire.enable = lib.mkEnableOption "pipewire";
    pulseaudio.enable = lib.mkEnableOption "pulseaudio";
  };

  config = {
    sound.enable = true;

    # Not strictly required but pipewire will use rtkit if it is present
    security.rtkit.enable = true;
    services.pipewire = mkIf cfg.pipewire.enable {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.pulseaudio = mkIf cfg.pulseaudio.enable {
      enable = true;
      # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
      #      for pulseaudio, which I likely don't need. Is there a better way?
      configFile =
        let inherit (pkgs) runCommand pulseaudio;
            paConfigFile =
              runCommand "disablePulseaudioEsoundModule"
                { buildInputs = [ pulseaudio ]; } ''
                mkdir "$out"
                cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
                sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
              '';
        in mkIf config.hardware.pulseaudio.enable
          "${paConfigFile}/default.pa";
    };

    users.users.daf.extraGroups = [ "audio" ];
  };
}
