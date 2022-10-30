{ config, ... }:

let github_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXgKC7XCa2PaLFBxPuN79jhreqTUZsSF3suI/c/EQ7M";
in
{
  home-manager.users."${config.vars.username}" = {
    home.file.".ssh/gh-captainspof@daftop.pub".text = github_key;
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/gh-captainspof@daftop.pem";
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
