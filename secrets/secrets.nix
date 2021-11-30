let
  # set ssh public keys here for your system and user
  dafbox.daf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkMUUwRW95/DuanXq8qh3Jfjo5RIkKUvx3NPGc6P8A0 daf@dafbox";
  allKeys = [ dafbox.daf ];
in
{
  "daf.age".publicKeys = allKeys;
}
