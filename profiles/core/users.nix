{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$6$GyUEEikWZXWhwzoa$2RsF8ef3.RsI6FkgEtIa6KiZU5NtRBQyZlAFJEz9bVCOowc4KpdDCcribAOfDZBRx.Cg5Ix52J0ue2cchJb0A.";
      "${config.vars.username}" = {
        description = "Cédric Da Fonseca";
        shell = pkgs.fish;
        hashedPassword = "$6$gz0h6JXlZ2NE/U7W$JV1pcmILRo.oFkAA/73AdLhgANbqdOOONfGyOQgy.VF7NIfbjqanY/jTbVV3Bva8rMWmUNXJZC47ihTxhvHJc/";
        isNormalUser = true;
        extraGroups = [ "wheel" "input" ]
          ++ pkgs.lib.optional config.virtualisation.docker.enable "docker"
          ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
          ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
          ++ pkgs.lib.optional config.programs.light.enable "video"
          ++ pkgs.lib.optional config.services.pipewire.enable "audio";
          # ++ pkgs.lib.optional config.hardware.i2c.enable "i2c";
      };
    };
  };
}
