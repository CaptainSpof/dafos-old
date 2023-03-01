let
  # set ssh public keys here for your system and user
  daftop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop";
  dafbox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIET2RYV7eTvXNuTOfLVM3Q1ALrUkYNqMC9NawIoo6+Kb daf@dafbox";
  dafpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi";
  all = [ daftop dafbox dafpi ];
in
{

  "gh_key.age".publicKeys = all;
  "dafbox_key.age".publicKeys = [ dafbox ];
}
