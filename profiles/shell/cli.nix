{ config, pkgs, lib, ... }:

{
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [
      bandwhich # htop, but for network 🦀
      bat # cat, but pretty 🦀
      # Bash scripts that integrate bat with various command line tools.
      # https://github.com/eth-p/bat-extras/
      bat-extras.batman # manual pages using bat as the manual page formatter.
      bat-extras.batgrep # search through and highlight files using ripgrep.
      bat-extras.batdiff # Diff a file against the current git index, or display the diff between two files.
      # bat-extras.prettybat # Pretty-print source code and highlight it with bat.
      bottom # htop, but pretty 🦀
      comma
      dua # du, but pretty 🦀
      exa # ls, but pretty 🦀
      fd # find, but fast, also I know how to use it 🦀
      fzf # fuzzy finder, the original (probably not, who care)
      hck # cut, but rusty 🪓🦀
      jq # make JSON readable, well more readable
      just # just make it! Makefile, but simpler 🦀��
      killall # every last one of them (the processes, of course)
      lfs # df, but pretty 🦀
      macchina # neofetch, but fast 🦀
      manix # man, but for nix
      miniserve # serve files locally 🦀
      navi # retired from helping Link to help you suck less at bash 🦀
      pastel # a color picker in a terminal ? Genius. 🦀
      procs # ps, but pretty 🦀
      rclone # copy stuff to/from the cloud
      ripgrep # grep, but fast 🦀
      skim # fzf, but rusty 🦀
      tealdeer # yeah, I need all the help; tldr but rusty 🦀
      tokei # need to know how many lines of poorly written code you typed ? 🦀
      trash-cli
      watchexec # watch, then exec; run commands when a file changes 🦀
      wmctrl # even X need some CLIs
      xh # httpie, but rusty 🦀
    ];

    programs = {
      # go directly to dir, do not pass GO, do not collect 200$ �
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd=c" ];
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # a prompt theme, but I can explain why it's a mess (not really) �
      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          format = ''$nix_shell$directory$aws$all$package$fill$vcsh$git_commit$git_state$git_metrics$git_branch$git_status
$cmd_duration$jobs$battery$status$shell$custom$memory_usage$character'';
          right_format = "$time";

          add_newline = true;

          time = {
            disabled = false;
            style = "#939594";
            format = "[$time]($style)";
          };

          character = {
            success_symbol = "[⏵](bright-red)[⏵](bright-blue)[⏵](bright-cyan)";
            error_symbol = "[⏵⏵⏵](red)";
            vicmd_symbol = "[⌜](bold purple)";
          };

          cmd_duration = {
            show_notifications = true;
            notification_timeout = 3500;
            min_time_to_notify = 30000;
            format = "[ $duration ]($style)";
          };

          fill.symbol = " ";
          line_break = {
            disabled = true;
          };

          battery = {
            format = "[$symbol $percentage]($style) ";
            full_symbol = " ";
            charging_symbol = " ";
            discharging_symbol = " ";
            unknown_symbol = " ";
            empty_symbol = " ";
          };

          directory = {
            format = "[ $path ]($style)[$read_only]($read_only_style) ";
            style = "fg:#999cb2 bg:#2d2f40 bold";
            read_only = "  ";
            read_only_style = "fg:black bg:red";
            truncation_length = 1;
          };

          memory_usage = {
            disabled = false;
            threshold = 70;
            symbol = "🐏";
            style = "bold dimmed red";
          };

          aws = {
            style = "bold #bb7445";
            symbol = "🌩  ";
            expiration_symbol = "🔒 ";
            format = "· [$symbol($profile )($duration )]($style) ";
          };

          git_branch = {
            style = "#2d2f40 bold";
            symbol = "";
            format = "[ $symbol ](fg:#e84d31 bg:$style)[$branch ](fg:#999cb2 bg:$style)";
          };

          git_status = {
            style = "#2d2f40";
            conflicted = "[ ](bold fg:88 bg:#2d2f40)[  $count ](fg:#999cb2 bg:#2d2f40)";
            staged = "[+ $count ](fg:#999cb2 bg:#2d2f40)";
            modified = "[ $count ](fg:#999cb2 bg:#2d2f40)";
            renamed = "[ $count ](fg:#999cb2 bg:#2d2f40)";
            deleted = "[ $count ](fg:#999cb2 bg:#2d2f40)";
            untracked = "[?$count ](fg:#999cb2 bg:#2d2f40)";
            stashed = "[ $count ](fg:#999cb2 bg:#2d2f40)";
            ahead = "[ $count ](fg:#523333 bg:#2d2f40)";
            behind = "[ $count ](fg:#999cb2 bg:#2d2f40)";
            diverged = "[ ](fg:88 bg:#2d2f40)[ נּ ](fg:#999cb2 bg:#2d2f40)[ $ahead_count ](fg:#999cb2 bg:#2d2f40)[ $behind_count ](fg:#999cb2 bg:#2d2f40)";
            format = "((bg:$style fg:#999cb2)$conflicted$staged$modified$renamed$deleted$untracked$stashed$ahead_behind(fg:$style))";
          };

          git_commit = {
            style = "#2d2f40";
            format = "(bg:$style)[\\($hash$tag\\)](fg:#999cb2 bg:$style)(fg:$style)";
          };

          git_state = {
            style = "#2d2f40";
            format = "(bg:$style)[ \\($state( $progress_current/$progress_total)\\)](fg:#999cb2 bg:$style)(fg:$style)";
          };

          nodejs = {
            format = "· [$symbol($version )]($style) ";
          };

          rust = {
            style = "bold #d2470a";
            format = "· [$symbol($version )]($style) ";
          };

          nix_shell = {
            symbol = "❄";
            impure_msg = "[ ❄⁣ ](fg:white bg:red bold)";
            pure_msg = "[ ❄⁣ ](fg:white bg:blue bold)";
            format = "[$state]($style)";
          };
          package.format = "· [$symbol$version]($style) ";

        };
      };
    };

    home.sessionVariables = { DIRENV_LOG_FORMAT = ""; };
  };
  programs.less.configFile = ./lesskey;
}
