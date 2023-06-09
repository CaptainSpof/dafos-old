{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.editor.vscode;
in {
  options.profiles.editor.vscode = {
    enable = mkOption { type = types.bool; default = true; };
  };
  config = mkIf cfg.enable {
    home-manager.users."${config.vars.username}" = {

      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          eamodio.gitlens
          alefragnani.project-manager
          ms-python.python
          # arrterian.nix-env-selector
          mkhl.direnv
        ];
        enableUpdateCheck = false;
        userSettings = {
          "terminal.integrated.fontFamily" = "Hack";
        };
      };
    };
  };
}
