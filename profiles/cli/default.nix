{ config, lib, pkgs, ... }:

let inherit (lib) fileContents;
in
{
    environment.systemPackages = with pkgs; [
        bandwhich           # htop, but for network 🦀
        bat                 # cat, but pretty 🦀
        bottom              # htop, but pretty 🦀
        dua                 # du, but pretty 🦀
        exa                 # ls, but pretty 🦀
        fd                  # find, but fast, also I know how to use it 🦀
        fzf                 # fuzzy finder, the original (probably not, who care)
        hck                 # cut, but rusty 🪓🦀
        ht-rust             # httpie, but rusty 🦀
        jq                  # make JSON readable, well more readable
        killall             # every last one of them (the processes, of course)
        lfs                 # df, but pretty 🦀
        macchina            # neofetch, but fast 🦀
        navi                # retired from helping Link to help you suck less at bash 🦀
        pastel              # a color picker in a terminal ? Genius. 🦀
        procs               # ps, but pretty 🦀
        # rbw                 # bitwarden cli, but rusty 🦀
        rclone              # copy stuff to/from the cloud
        ripgrep             # grep, but fast 🦀
        skim                # fzf, but rusty 🦀
        # starship            # a prompt theme, but I can explain why it's a mess (not really) 🦀
        tealdeer            # yeah, I need all the help; tldr but rusty 🦀
        tokei               # need to know how many lines of poorly written code you typed ? 🦀
        watchexec           # watch, then exec; run commands when a file changes 🦀
        wmctrl              # even X need some CLIs
        # zoxide              # go directly to dir, do not pass GO, do not collect 200$ 🦀
    ];

    programs.zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableCompletion = true;
    };

    programs.zsh.dotDir = ".config/zsh";

    environment = {
        shellInit = ''
      export STARSHIP_CONFIG=${
                         pkgs.writeText "starship.toml"
                             (fileContents ./starship.toml)
                     }
    '';
    };

    # go directly to dir, do not pass GO, do not collect 200$ 🦀
    # programs.zoxide = {
    #     enable = true;
        # enableZshIntegration = true;
        # options = [ "--cmd=c" ];
    # };

}
