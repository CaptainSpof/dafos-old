{ suites, profiles, ... }: {
  imports = [ ./configuration.nix profiles.network ] ++ suites.base;

  bud.enable = true;
  bud.localFlakeClone = "/home/daf/.config/dafos";
}
