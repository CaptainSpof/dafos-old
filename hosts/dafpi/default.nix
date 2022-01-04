{ suites, profiles, ... }: {
  imports = [ ./configuration.nix profiles.network ] ++ suites.base;

  home-manager.users.daf = { suites, ... }: {
    imports = suites.graphical;
  };

  bud.enable = true;
  bud.localFlakeClone = "/home/daf/.config/dafos";
}
