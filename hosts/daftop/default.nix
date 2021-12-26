{ suites, profiles, ... }:
{
  imports = [
    ./configuration.nix
    profiles.hardware.audio
    profiles.network
  ] ++ suites.workstation;

  bud.enable = true;
  bud.localFlakeClone = "/home/daf/.config/dafos";

  profiles.hardware.audio.pipewire.enable = true;
}
