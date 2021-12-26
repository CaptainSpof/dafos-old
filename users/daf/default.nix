{ self, hmUsers, config, ... }:
{
  home-manager.users = { inherit (hmUsers) daf; };

  age.secrets = {
    daf.file = "${self}/secrets/daf.age";
  };

  users.users.daf = {
    uid = 1111;
    description = "Cédric Da Fonseca";
    isNormalUser = true;
    extraGroups = [ "audio" "wheel" ];
    password = "daf";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi"
    ];
    shell = "/etc/profiles/per-user/daf/bin/zsh";
    # passwordFile = "/run/secrets/daf";
  };
  # TODO: find a way to set options per user
  # users.git.user.name = "CaptainS";
  # profiles.git.user.email = "captain.spof@gmail.hihi";
}
