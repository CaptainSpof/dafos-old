{ config, lib, pkgs, ... }:

{
  home-manager.users."${config.vars.username}" = {
    home = {
      username = "${config.vars.username}";
      homeDirectory = "${config.vars.home}";
      stateVersion = config.system.stateVersion;
      sessionVariables = {
        EDITOR = "emacs";
        VISUAL = "emacs";
        PAGER = "less -R";
        TERMINAL = "${config.vars.terminal}";
        BROWSER = "firefox";
      };
      packages = with pkgs; [
        neofetch
        rclone
      ];
    };
    programs = {
      home-manager.enable = true;
      bottom.enable = true;
      bat = {
        enable = true;
        config = { theme = "zenburn"; pager = "less"; };
      };
      skim = rec {
        enable = true;
        defaultCommand = "fd --type f --hidden --exclude '.git'";
        defaultOptions = [ "--height 40%" "--inline-info" ];
        changeDirWidgetCommand = "fd --type d --hidden --exclude '.git'";
        fileWidgetCommand = defaultCommand;
        fileWidgetOptions = [ "--preview 'bat --color always {} 2> /dev/null | head -200; highlight -O ansi -l {} ^ /dev/null | head -200 || cat {} ^ /dev/null | head -200'" ];
      };
    };
  };
}
