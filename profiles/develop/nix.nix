{ lib, config, pkgs, ... }:

with lib;
let cfg = config.profiles.develop.nix;
in {
  options.profiles.develop.nix = {
    enable = mkOption { type = types.bool; default = true; };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {
      home.packages = with pkgs; [ nil nixpkgs-fmt nixfmt ];
    };
  };
}
