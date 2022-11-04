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
      programs.emacs = {
        enable = true;
        # let's be reasonable for now, emacs 28 it is…
        # but the fancy new features!! I am not reasonable, hello again emacs 29.
        package = (pkgs.emacsPgtkNativeComp.override {
          withXwidgets = false;
        });
        extraPackages = (epkgs: with epkgs; [ vterm pdf-tools sqlite ]);
      };
      home.packages = with pkgs; [
        gcc
        sqlite
        (aspellWithDicts (ds: with ds; [ en en-computers en-science fr ]))
      ];
    };
  };
}
