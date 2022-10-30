{ config, pkgs, lib, ... }:

{
  home-manager.users."${config.vars.username}" = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        fish_default_key_bindings
      '';
      shellAbbrs = rec {
        # nix
        n = "nix";
        ns = "nix search --no-update-lock-file nixpkgs";
        nf = "nix flake";
        nfu = "nix flake update";
        nepl = "nix repl '<nixpkgs>'";
        nrb = ''nixos-rebuild --use-remote-sudo --flake "$(pwd)#$(hostname)"'';
        nrbs = "${nrb} switch";
        ndiff = "nix store diff-closures /nix/var/nix/profiles/(ls -r /nix/var/nix/profiles/ | grep -E 'system\-' | sed -n '2 p') /nix/var/nix/profiles/system";

        # sudo
        # s = "sudo -E";
        # si = "sudo -i";
        # se = "sudoedit";

        # git
        g = "git";
        ga = "git add";
        "ga." = "git add .";
        gamend = "git commit --amend --no-edit";
        gb = "git branch";
        gc = "git commit";
        gcl = "git clone";
        gl = ''git log --graph --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'';
        gco = "git checkout";
        gd = "git diff";
        gds = "git diff --staged";
        gp = "git push";
        gpf = "git push --force-with-lease";
        grc = "git rebase --continue";
        gri = "git rebase --interactive";
        gra = "git rebase --abort";
        grs = "git rebase --skip";
        gs = "git status --short";
        gS = "git status";
        gst = "git stash";
        gstl = "git stash list";
        gstp = "git stash pop";

        # systemd
        sys = "sudo systemctl";
        sysu = "systemctl --user";
        jtl = "journalctl";
        jtlb = "journalctl -b";
        jtlu = "journalctl -u";

        # apps
        kc = "kdeconnect-cli -n dafphone";
        da = "direnv allow";
      };

      shellAliases = rec {
        ls="exa";
        sl="ls";
        exa="exa --group-directories-first --git";
        l="exa -blF";
        ll="exa -abghilmu";
        llm="ll --sort=modified";
        la="LC_COLLATE=C exa -ablF";
        tree="exa --tree";

        cat = "bat";
        vim = "nvim";
      };
      functions = {
        fish_greeting = "";
        "-" = "cd -";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        # bwu = "set -Ux BW_SESSION (bw unlock --raw)";
        # genpass = "bw generate -ulns --length 16";
        rm = "trash $argv";
        mn = ''manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix'';
        fwifi = {
          body = "nmcli -t -f SSID device wifi list | grep . | sk | xargs -o -I_ nmcli --ask dev wifi connect '_'";
          description = "Fuzzy connect to a wifi";
        };
      };
      plugins = [
        {
          name = "anicode";
          src = pkgs.fetchFromGitHub {
            owner = "igalic";
            repo = "anicode";
            rev = "982709ba6619dd758e83c0e7126356fccabf2379";
            sha256 = "Vu1gioUMbCa/AVTMQMkC+dskcUqXyHP6Tay/gsVu+Pc=";
          };
        }
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "1.16.5";
            sha256 = "E0wveeDw1VzEH2kzn63q9hy1xkccfxQHBV2gVpu2IdQ=";
          };
        }
        {
          name = "bang-bang";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-bang-bang";
            rev = "f969c618301163273d0a03d002614d9a81952c1e";
            sha256 = "sha256-A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
          };
        }
      ];
    };

    programs = {
      keychain.enableFishIntegration = true;
      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };
    };

    home.sessionVariables = { DIRENV_LOG_FORMAT = ""; };
  };
}