let
  # set ssh public keys here for your system and user
  dafbox.daf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox";
  daftop.daf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop";
  dafpi.daf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi";
  allKeys = [ dafbox.daf daftop.daf dafpi.daf ];
in
{
  "daf.age".publicKeys = allKeys;
}
