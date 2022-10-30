{ config, lib, pkgs, ... }:

{
  environment.sessionVariables.PATH = [ "$HOME/.config/emacs/bin" ];
  home-manager.users."${config.vars.username}" = {
    programs.emacs = {
      enable = true;
      # let's be reasonable for now, emacs 28 it is.
      package = (pkgs.emacsNativeComp.override {
        withXwidgets = false;
      });
      extraPackages = (epkgs: with epkgs; [ vterm pdf-tools sqlite ]);
    };
    home.packages = with pkgs; [ sqlite ];
  };
}
