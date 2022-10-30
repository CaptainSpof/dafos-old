{ self, config, pkgs, ... }:

{
  vars = rec {
    email = "captain.spof@gmail.com";
    username = "daf";
    terminal = "alacritty";
    terminalBin = "${pkgs.alacritty}/bin/alacritty";

    home = "/home/${username}";
    configHome = (builtins.getAttr username config.home-manager.users).xdg.configHome;
    documentsFolder = "Documents";
    downloadFolder = "Downloads";
    musicFolder = "Music";
    picturesFolder = "Pictures";
    projectsFolder = "Projects";
    videosFolder = "Videos";
    repositoriesFolder = "Repositories";
    screenshotFolder = "${picturesFolder}/screenshots";
    screencastFolder = "${videosFolder}/screencasts";
    wallpaper = ./desktop/plasma/wallpapers/nixos.png;

    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop";
  };
}
