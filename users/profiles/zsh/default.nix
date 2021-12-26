{ config, lib, pkgs, ... }:
{
  config = with lib; mkMerge [
    ({
      home.packages = with pkgs;[
        zoxide
      ];

      programs.ssh = {
        enable = true;

	matchBlocks = {
	  "github.com" = {
	    hostname = "github.com";
	    identityFile = "~/.ssh/daf@dafpi.pem";
	  };
	"daftop" = {
	  hostname = "daftop";
	  user = "daf";
	  identityFile = "~/.ssh/daf@dafpi.pem";
	};
	};
      };

      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        autocd = true;
        dotDir = ".config/zsh";
        enableAutosuggestions = true;
        enableCompletion = true;
        history = {
          path = config.programs.zsh.dotDir + "/.zsh_history";
          share = true;
          save = 10000000;
          ignoreDups = true;
          extended = true;
          size = 10000000;
        };
        shellAliases = with pkgs; {
          ls = "exa";
          l = "exa -lah";
	  ll = "exa -lah";
          la = "ls -la";
          f = "rg --files";
          E = "env SUDO_EDITOR=\"emacsclient\" sudo -e";
          e = "emacsclient";
          em = "emacs";
          cp = "cp -i";
          mv = "mv -i";
          gst = "${pkgs.gst}/bin/gst";
          cdghq = "cd $(ghq root)/$(ghq list | peco)";
          cdgst = "cd $(gst --short | peco)";
          ##update Nixpkgs
          fp = "git fetch && git pull";
          ag0 = "rg --max-depth=1";
        };

      };

      home.file = {
        ".config/zsh/.zshrc".text = ''
          unsetopt BRACE_CCL        # Allow brace character class list expansion.
      '';
      };

    })
  ];
}
