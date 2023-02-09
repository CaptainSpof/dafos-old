{ config, ... }:

{
  imports = [ ./core/tailscale.nix ];

  documentation.enable = false;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };

  programs.mosh.enable = true;

  services = {
    openssh = {
      enable = true;
      settings.passwordAuthentication = false;
    };
    tailscale.enable = false;
    xserver = {
      layout = "fr";
      xkbVariant = "bepo";
      # TODO: find a way to replace caps lock with ctrl (not swapping). Also, single press should be esc.
      xkbOptions = "caps:escape";
    };
  };

  # activate keyboard layout in console too
  console.useXkbConfig = true;

  users.users.root.openssh.authorizedKeys.keys = [ config.vars.sshPublicKey ];
}
