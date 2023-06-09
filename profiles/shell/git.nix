{ config, pkgs, ... }:

{
  home-manager.users."${config.vars.username}" = {

    home.packages = with pkgs; [
      gitAndTools.gh
    ];

    programs.git = {
      enable = true;
      userEmail = config.vars.email;
      # TODO: add var
      userName = "CaptainSpof";
      ignores = [ "venv" ".env" "pyrightconfig.json" "shell.nix" ".envrc" ".direnv" ];
      extraConfig = {
        pull.rebase = "true";
        branch.autosetuprebase = "always";
        init.defaultBranch = "main";
        # gpg.format = "ssh";
        user.signingKey = "${config.vars.sshPublicKey}";
        commit.gpgSign = "false";
        tag.gpgSign = "false";
      };
      aliases = {
        ll = "log --graph --date='short' --color=always --pretty=format:'%Cgreen%h %Cred%<(15,trunc)%an %Cblue%cd %Creset%s'";
      };
      delta = {
        enable = true;
        options = {
          dark = true;
          plus-style = "syntax #012800";
          minus-style = "syntax #340001";
          syntax-theme = "Monokai Extended";
          navigate = "true";
        };
      };
    };
  };
}
