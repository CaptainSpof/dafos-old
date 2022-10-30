{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    socketActivation = true;
    wireplumber.enable = true;
    media-session.enable = false;
  };
}
