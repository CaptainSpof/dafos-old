{ config, ... }:

let
  daftopRootKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+WUE0u1TwkPF2yhetXKVPSpZrfxTW72hSzBcsL0Z8z root@daftop'';
in
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
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };
    tailscale.enable = true;
    xserver = {
      layout = "fr";
      xkbVariant = "bepo";
      # TODO: find a way to replace caps lock with ctrl (not swapping). Also, single press should be esc.
      xkbOptions = "caps:escape";
    };
  };

  # activate keyboard layout in console too
  console.useXkbConfig = true;

  users.users.root.openssh.authorizedKeys.keys = [ config.vars.sshPublicKey daftopRootKey ];
}
