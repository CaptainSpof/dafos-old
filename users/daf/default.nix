{ self, hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) daf; };

  age.secrets = {
    daf.file = "${self}/secrets/daf.age";
  };

  users.users.daf = {
    uid = 1111;
    description = "Cédric Da Fonseca";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "daf";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox"
    ];
    shell = "/etc/profiles/per-user/daf/bin/zsh";
    # passwordFile = "/run/secrets/daf";
  };
}
