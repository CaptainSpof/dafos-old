{ self, ... }:
{
  home-manager.users.daf = { suites, profiles, ... }: {
    # programs.ssh = {
    #   enable = true;

    #   matchBlocks = {
    #     dafbox = {
    #       host = "dafbox";
    #       identityFile = ../secrets/path/to/key;
    #       extraOptions = { AddKeysToAgent = "yes"; };
    #     };
    #   };
    # };
  };

  age.secrets = {
    daf.file = "${self}/secrets/daf.age";
  };

  users.users.daf = {
    uid = 1001;
    description = "Cédric Da Fonseca";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "daf";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox"
    ];
    # passwordFile = "/run/secrets/daf";
  };
}
