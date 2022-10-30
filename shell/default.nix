{ self, inputs, ... }:
{
  modules = with inputs; [];
  exportedModules = [
    ./dafos.nix
  ];
}

