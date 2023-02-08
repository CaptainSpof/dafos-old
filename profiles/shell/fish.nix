{ config, pkgs, lib, ... }:

{
  home-manager.users."${config.vars.username}" = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        fish_default_key_bindings
      '';
      shellAbbrs = rec {
        # ls
        lst = "ls -T";
        lS = "ls -1";

        # bat
        bdiff = "batdiff";
        brg = "batgrep";

        # nix
        n = "nix";
        ns = "nix search --no-update-lock-file nixpkgs";
        nf = "nix flake";
        nfu = "nix flake update";
        nepl = "nix repl '<nixpkgs>'";
        nrb = ''nixos-rebuild --use-remote-sudo --flake "$(pwd)#$(hostname)"'';
        nrbs = "${nrb} switch";
        ndiff = "nix store diff-closures /nix/var/nix/profiles/(ls -r /nix/var/nix/profiles/ | grep -E 'system\-' | sed -n '2 p') /nix/var/nix/profiles/system";

        # nu
        nu = "nu -c";

        # rm
        rmf = "rm -rf";

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
        gdt = "git difftool";
        gds = "git diff --staged";
        gp = "git push";
        gpf = "git push --force-with-lease";
        gf = "git fetch";
        gF = "git pull";
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
        j = "journalctl";
        jb = "journalctl -b";
        ju = "journalctl -u";

        # apps
        kc = "kdeconnect-cli -n dafphone";
        da = "direnv allow";

        # misc
        q = "exit";
        mkdir = "mkdir -pv";
        y = "xclip -selection clipboard -in";
        p = "xclip -selection clipboard -out";
        pp = "pwd";
        "~~" = "cd $PRJ_ROOT";
      };

      shellAliases = rec {
        exa = "exa --group-directories-first --git";
        ls = "${exa}";
        sl = "${exa}";
        l = "${exa} -blF";
        ll = "${exa} -abghilmu --icons";
        llm = "${ll} --sort=modified";
        la = "LC_COLLATE=C ${exa} -ablF";
        tree = "${exa} -T";

        cat = "bat";
        man = "batman";
        vim = "nvim";
      };
      functions = {
        fish_greeting = "";
        rm = "trash $argv";
        mn = ''manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix'';
        fwifi = {
          body = "nmcli -t -f SSID device wifi list | grep . | sk | xargs -o -I_ nmcli --ask dev wifi connect '_'";
          description = "Fuzzy connect to a wifi";
        };
      };
      plugins = [
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
          name = "puffer-fish";
          src = pkgs.fetchFromGitHub {
            owner = "nickeb96";
            repo = "puffer-fish";
            rev = "fd0a9c95da59512beffddb3df95e64221f894631";
            sha256 = "sha256-aij48yQHeAKCoAD43rGhqW8X/qmEGGkg8B4jSeqjVU0=";
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

    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      EXA_ICON_SPACING = "2";
    };
  };
}
