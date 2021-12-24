{ self, hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) steeve; };

  age.secrets = {
    steeve.file = "${self}/secrets/steeve.age";
  };

  users.users.steeve = {
    uid = 1002;
    description = "Steeve, friend";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "steeve";
    # shell = "/etc/profiles/per-user/daf/bin/zsh";
    # passwordFile = "/run/secrets/daf";
  };
}
