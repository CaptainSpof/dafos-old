{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.editor.emacs;
in {
  options.profiles.editor.emacs = {
    enable = mkOption { type = types.bool; default = true; };
  };
  config = mkIf cfg.enable {
    environment.sessionVariables.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    home-manager.users."${config.vars.username}" = {
      services.emacs.enable = true;
      services.emacs.package = pkgs.emacs-pgtk;
      programs.emacs = {
        enable = true;
        package = (pkgs.emacs-pgtk.override {
          withXwidgets = false;
        });
        extraPackages = (epkgs: with epkgs; [ vterm pdf-tools sqlite ]);
      };
      home.packages = with pkgs; [
        djvu2pdf
        gcc
        sqlite
        nodePackages.mermaid-cli
        texlive.combined.scheme-full
        (aspellWithDicts (ds: with ds; [ en en-computers en-science fr ]))
      ];
    };
  };
}
