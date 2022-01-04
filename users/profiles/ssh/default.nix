{ config, lib, pkgs, ... }:

{

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/daf@dafpi.pem";
      };
      "dafbox" = {
        hostname = "dafbox";
        user = "daf";
        identityFile = "~/.ssh/daf@dafpi.pem";
      };
      "daftop" = {
        hostname = "daftop";
        user = "daf";
        identityFile = "~/.ssh/daf@dafpi.pem";
      };
    };
  };
}
