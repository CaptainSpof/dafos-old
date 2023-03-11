{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.defaultPackages = with pkgs; [
    ethtool
    nixpkgs-review
    xdotool
    xorg.xwininfo
  ];

  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_BIN_HOME    = "$HOME/.local/bin";
  };

  home-manager.users."${config.vars.username}" = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.vars.home}/${config.vars.documentsFolder}";
      download = "${config.vars.home}/${config.vars.downloadFolder}";
      music = "${config.vars.home}/${config.vars.musicFolder}";
      pictures = "${config.vars.home}/${config.vars.picturesFolder}";
      videos = "${config.vars.home}/${config.vars.videosFolder}";
      desktop = "${config.vars.home}";
      publicShare = "${config.vars.home}";
      templates = "${config.vars.home}";
      extraConfig = {
        XDG_PROJECTS_DIR = "${config.vars.home}/${config.vars.projectsFolder}";
        XDG_REPOSITORIES_DIR = "${config.vars.home}/${config.vars.repositoriesFolder}";
      };
    };
  };
}
