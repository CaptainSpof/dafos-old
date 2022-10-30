{ config, lib, pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.supportDDC = true;
  services.xserver.displayManager.sddm.settings.Wayland.SessionDir =
    "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  environment.systemPackages = with pkgs;
    [
      plasma-integration
      # maliit-keyboard # virtual keyboard (won't shut up, spamming dmessage)
    ] ++ (with libsForQt5; [ bismuth lightly ]);

  home-manager.users."${config.vars.username}" = {

    programs.plasma = {
      enable = true;

      # Some high-level settings:
      workspace.clickItemTo = "select";

      # hotkeys.commands."Launch Konsole" = {
      #   key = "Meta+Return";
      #   command = "alacritty";
      # };

      # Some mid-level settings:
      shortcuts = {
        "Alacritty.desktop"."New" = "Meta+Return";
        "alacrittydropdown.sh.desktop"."_launch" = "Meta+D";

        bismuth = {
          "toggle_window_floating" = "Meta+F";

          "increase_window_height" = "Meta+Ctrl+S";
          "decrease_window_height" = "Meta+Ctrl+T";
          "increase_window_width" = "Meta+Ctrl+R";
          "decrease_window_width" = "Meta+Ctrl+C";

          "move_window_to_upper_pos" = "Meta+Shift+S";
          "move_window_to_next_pos" = "Meta+Shift+R";
          "move_window_to_prev_pos" = "Meta+Shift+C";
          "move_window_to_bottom_pos" = "Meta+Shift+T";

          "next_layout" = "Meta+/";
          "prev_layout" = "Meta+Shift+/";
        };
        ksmserver = {
          "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
        };

        kwin = {
          "Switch Window Down" = "Meta+T";
          "Switch Window Left" = "Meta+C";
          "Switch Window Right" = "Meta+R";
          "Switch Window Up" = "Meta+S";
          "Switch to Next Desktop" = "Meta+H";
          "Switch to Previous Desktop" = "Meta+G";
          "Window One Desktop to the Left" = "Meta+Shift+G";
          "Window One Desktop to the Right" = "Meta+Shift+H";
          "Window On All Desktops" = "Meta+Alt+A";
          "Window Close" = [ "Alt+F4" "Meta+Q"];
        };

        "org.kde.krunner.desktop"."_launch" = ["Meta+Space" "Alt+F2" "Search"];
      };

      # A low-level setting:
      files = {
        "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;

        "kdeglobals"."KDE"."widgetStyle" = "Lightly";

        "kwinrc"."Desktops"."Number" = 4;
        "kwinrc"."Desktops"."Rows" = 1;
        "kwinrc"."NightColor"."Active" = true;
        "kwinrc"."Plugins"."bismuthEnabled" = true;
        "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "NHIAX";
        "kwinrc"."Script-bismuth"."untileByDragging" = false;
        "kwinrc"."Script-bismuth"."maximizeSoleTile" = true;
        "kwinrc"."Script-bismuth"."enableFloatingLayout" = true;
        "kwinrc"."Script-bismuth"."floatingClass" = "alacrittydropdown";
        "kwinrc"."Script-bismuth"."ignoreClass" = "yakuake,spectacle,Conky,zoom,org.kde.polkit-kde-authentication-agent-1";
        "kwinrc"."Script-bismuth"."newWindowAsMaster" = true;
        "kwinrc"."Script-bismuth"."noTileBorder" = true;
        "kwinrc"."Script-bismuth"."screenGapBottom" = 15;
        "kwinrc"."Script-bismuth"."screenGapLeft" = 15;
        "kwinrc"."Script-bismuth"."screenGapRight" = 15;
        "kwinrc"."Script-bismuth"."screenGapTop" = 15;
        "kwinrc"."Script-bismuth"."tileLayoutGap" = 15;

        # TODO: use ${pkgs.maliit}
        # "kwinrc"."Wayland"."InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
        # "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
        "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
        "kwinrc"."ModifierOnlyShortcuts"."Meta" = "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,Overview";

        "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."ClickMethod" = 2;
        "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."NaturalScroll" = true;
        "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."TapToClick" = true;

        "ksmserverrc"."General"."loginMode" = "emptySession";
        "ksmserverrc"."General"."shutdownType" = 2;

        "krunnerrc"."General"."FreeFloating" = true;

        "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
        "plasma-localerc"."Formats"."LC_ADDRESS" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_MEASUREMENT" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_MONETARY" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_NAME" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_PAGE" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_TELEPHONE" = "fr_FR.UTF-8";
        "plasma-localerc"."Formats"."LC_TIME" = "fr_FR.UTF-8";
      };
    };
  };
}
