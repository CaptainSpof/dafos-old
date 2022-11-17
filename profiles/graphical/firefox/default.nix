{ config, pkgs, lib, ... }:

with lib;
{
  nixpkgs.config.firefox.enableTridactylNative = true;
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  home-manager.users."${config.vars.username}" = {
    programs.firefox = {
      enable = true;
      profiles."${config.vars.username}".settings = {
        # Your customized toolbar settings are stored in
        # 'browser.uiCustomization.state'. This tells firefox to sync it between
        # machines. WARNING: This may not work across OSes. Since I use NixOS on
        # all the machines I use Firefox on, this is no concern to me.
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        # Enable ETP for decent security (makes firefox containers and many
        # common security/privacy add-ons redundant).
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.purge_trackers.enabled" = true;
        # Don't use the built-in password manager.
        "signon.rememberSignons" = false;
        # Do not check if Firefox is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" =
          true; # "Looks like you haven't started Firefox in a while."
        "browser.onboarding.enabled" =
          false; # "New to Firefox? Let's get started!" tour
        "browser.aboutConfig.showWarning" =
          false; # Warning when opening about:config
        # Disable telemetry (most of them anyway)
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "extensions.pocket.enabled" = false;
        "svg.context-properties.content.enabled" = true;
      }
      # Allow to use Qt file picker
      // (mkIf (config.profiles.desktop.plasma.enable) {
        "widget.use-xdg-desktop-portal" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
      });

      extensions =
        with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          plasma-integration
          multi-account-containers
          org-capture # TODO: setup
          simple-tab-groups
          tridactyl
          user-agent-string-switcher
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
      # FIXME: unfortunately I can't seem to be able to share my screen with
      # slack while this is active. But if I disable it, I lose the gestures.
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
    };

    # REVIEW: kde handles it?
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
