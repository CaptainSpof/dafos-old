{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  environment.defaultPackages = with pkgs; [
    spotify # TODO: move out
    ethtool
    gitui
    manix
    nixpkgs-review
    tealdeer
    wol
  ];

  services = {
    # REVIEW: checkout getty
    # getty = {
    #   extraArgs = [ "--skip-login" ];
    #   loginOptions = "${config.vars.username}";
    # };
    # printing = {
    #   enable = true;
    #   drivers = with pkgs; [ gutenprint gutenprintBin hplip ];
    # };
  };

  home-manager.users."${config.vars.username}" = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.vars.home}/${config.vars.documentsFolder}";
      download = "${config.vars.home}/${config.vars.downloadFolder}";
      music = "${config.vars.home}/${config.vars.musicFolder}";
      pictures = "${config.vars.home}/${config.vars.picturesFolder}";
      templates = "${config.vars.home}/${config.vars.repositoriesFolder}";
      videos = "${config.vars.home}/${config.vars.videosFolder}";
      desktop = "${config.vars.home}";
      publicShare = "${config.vars.home}";
    };
  };
}
