final: prev: {
  slack = prev.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${prev.lib.makeBinPath [prev.pkgs.xdg-utils]} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WebRTCPipeWireCapturer}}"
        '';
  });
}
