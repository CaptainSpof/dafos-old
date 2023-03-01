{ config, ... }:

let github_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdlYbk5TRQj189jrlwwLqud4VuDPKxzuq/ns7rSuRbf captain.spof@gmail.com";
in
{
  home-manager.users."${config.vars.username}" = {
    home.file.".ssh/gh@captainspof.pub".text = github_key;
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/gh@captainspof.pem";
          identitiesOnly = true;
        };
        "gitlab.com" = {
          identityFile = "~/.ssh/oxp@daftop.pem";
          identitiesOnly = true;
        };
      };
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
  };

}
