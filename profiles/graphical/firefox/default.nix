{ config, pkgs, lib, ... }:

{
  nixpkgs.config.firefox.enableTridactylNative = true;
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  home-manager.users."${config.vars.username}" = {
    programs.firefox = {
      enable = true;
      profiles."${config.vars.username}".settings = {
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.uidensity" = 2;
        "extensions.pocket.enabled" = false;
      };
      extensions =
        with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          plasma-integration
          multi-account-containers
          org-capture # TODO: setup
          tridactyl
        ];
    };

    # Fix tridactyl & plasma integration
    home.file.".mozilla/native-messaging-hosts".source = pkgs.symlinkJoin {
      name = "native-messaging-hosts";
      paths = [
        "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts"
        "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts"
      ];
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    };

    # Tridactyl
    xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
    xdg.configFile."tridactyl/themes/base16-oceanicnext.css".source = ./tridactyl_style.css;
  };
}
