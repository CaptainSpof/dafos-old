{ config, pkgs, lib, ... }:

{
  home-manager.users."${config.vars.username}" = {
    programs.fish = {
      enable = true;
      shellInit = ''
        starship init fish | source
      '';
      interactiveShellInit = ''
        set fzf_history_opts "--bind=ctrl-r:toggle-sort,ctrl-z:ignore"
        set -a fzf_history_opts "--nth=4.."
        bind \cr _fzf_search_history # HACK: override CTRL+R binding to the one defined in fzf.fish plugin
      '';
      shellAbbrs = rec {
        # ls
        lt2 = "ls -TL 2";
        lS = "ls -1";

        # dysk
        lfs = "dysk";

        # bat
        bdiff = "batdiff";
        brg = "batgrep";

        # nix
        n = "nix";
        ns = "nix search --no-update-lock-file nixpkgs";
        nf = "nix flake";
        nfu = "nix flake update";
        nepl = "nix repl '<nixpkgs>'";
        nr = ''nixos-rebuild --use-remote-sudo --flake "$(pwd)#$(hostname)"'';
        nrb = "${nr} build";
        nrs = "${nr} switch";
        ncl = ''sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10'';
        ngc = ''nix store gc'';
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
        y = "wl-copy";
        p = "wl-paste";
        pp = "pwd";
        "~~" = "cd $PRJ_ROOT";
      };

      shellAliases = rec {
        exa = "exa --group-directories-first --git";
        ls = "${exa}";
        sl = "${exa}";
        l = "${exa} -blF --icons";
        ll = "${exa} -abghilmu --icons";
        llm = "${ll} --sort=modified";
        la = "LC_COLLATE=C ${exa} -ablF --icons";
        lt = "${exa} --tree";
        tree = "${exa} --tree";

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
          src = pkgs.fishPlugins.done;
        }
        {
          name = "puffer-fish";
          src = pkgs.fishPlugins.puffer;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces;
        }
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "63c8f8e65761295da51029c5b6c9e601571837a1";
            sha256 = "sha256-i9FcuQdmNlJnMWQp7myF3N0tMD/2I0CaMs/PlD8o1gw=";
          };
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages;
        }
        {
          name = "async-prompt";
          src = pkgs.fishPlugins.async-prompt.src;
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
