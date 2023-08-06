{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.desktop.plasma;
in {
  options.profiles.desktop.plasma = {
    enable = mkOption { type = types.bool; default = true; };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.settings.Wayland.SessionDir =
      "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
    services.xserver.displayManager.defaultSession = "plasmawayland";
    services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.desktopManager.plasma5.useQtScaling = true;
    services.xserver.desktopManager.plasma5.runUsingSystemd = true;

    security.pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };

    services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

    programs.partition-manager.enable = true;

    environment.systemPackages = with pkgs;
      [
        ark
        gparted
        kate
        lightly
        maliit-keyboard # virtual keyboard (won't shut up, spamming dmessage)
        plasma-integration
        qbittorrent
        sddm-kcm # add a useless entry in systemsettings, but it felt empty without it
        skanlite # TODO: move to own module ?
        xdg-desktop-portal-kde
      ] ++ (with libsForQt5; [
        bismuth
        kinfocenter
        frameworkintegration
        kio-extras
        dolphin-plugins
      ]);

    home-manager.users."${config.vars.username}" = {
      programs.plasma = {
        enable = true;

        # Some high-level settings:
        workspace.clickItemTo = "select";

        # Some mid-level settings:
        shortcuts = {
          "Alacritty.desktop"."New" = "Meta+Return";
          "alacrittydropdown.sh.desktop"."_launch" = "Meta+D";

          
          ksmserver."Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
          

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
            "Window to Next Screen" = ["Meta+Shift+Right" "Meta+Ctrl+Shift+R"];
            "Window to Previous Screen" = ["Meta+Shift+Left" "Meta+Ctrl+Shift+C"];
            "Window Fullscreen" = [ "Meta+Ctrl+F" ];
            "Edit Tiles" = "Meta+Alt+T";

            "PoloniumCycleLayouts" = "Meta+/";
            "PoloniumFocusAbove" = "Meta+S";
            "PoloniumFocusBelow" = "Meta+T";
            "PoloniumFocusLeft" = "Meta+C";
            "PoloniumFocusRight" = "Meta+R";
            "PoloniumInsertAbove" = "";
            "PoloniumInsertBelow" = "";
            "PoloniumInsertLeft" = [ ];
            "PoloniumInsertRight" = "";
            "PoloniumRebuildLayout" = "Meta+Ctrl+Space";
            "PoloniumResizeTileDown" = "Meta+Shift+T";
            "PoloniumResizeTileLeft" = "Meta+Shift+C";
            "PoloniumResizeTileRight" = "Meta+Shift+R";
            "PoloniumResizeTileUp" = "Meta+Shift+S";
            "PoloniumRetileWindow" = "Meta+Shift+Space";
            "PoloniumSwapAbove" = "Meta+Ctrl+S";
            "PoloniumSwapBelow" = "Meta+Ctrl+T";
            "PoloniumSwapLeft" = "Meta+Ctrl+C";
            "PoloniumSwapRight" = "Meta+Ctrl+R";

          };

          "org.kde.krunner.desktop"."_launch" = ["Meta+Space" "Alt+F2" "Search"];
        };

        # A low-level setting:
        configFile = {
          "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;

          "dolphinrc"."General"."ShowSpaceInfo" = false; # bottom right disk space indicator looks weird

          "kdeglobals"."KDE"."widgetStyle" = "Lightly";
          "kdeglobals"."KDE"."SingleClick" = false;

          "kded5rc"."Module-bluedevil"."autoload" = true;

          "kwinrc"."Desktops"."Number" = 4;
          "kwinrc"."Desktops"."Rows" = 1;

          "kwinrc"."Effect-overview"."BorderActivate" = 7;
          "kwinrc"."Effect-windowview"."BorderActivateAll" = 9;
          "kwinrc"."TabBox"."TouchBorderActivate" = 6;
          "kwinrc"."TouchEdges"."Bottom" = "ApplicationLauncher";

          # Use Meta key to invoke Overview, à la Gnome
          "kwinrc"."ModifierOnlyShortcuts"."Meta" = "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,Overview";

          "kwinrc"."NightColor"."Active" = true;

          "kwinrc"."Plugins"."bismuthEnabled" = true;
          "kwinrc"."Plugins"."blurEnabled" = true;
          "kwinrc"."Plugins"."diminactiveEnabled" = true;

          "kwinrc"."MouseBindings"."CommandAllWheel" = "Previous/Next Desktop";

          "kwinrc"."Windows"."ElectricBorderCooldown" = 400;
          "kwinrc"."Windows"."ElectricBorderDelay" = 350;
          "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
          "kwinrc"."Windows"."NextFocusPrefersMouse" = true;

          "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "NHIAX";
          # TODO: use ${pkgs.maliit}
          "kwinrc"."Wayland"."InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
          "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
          # Bismuth · Tiling
          # "kwinrc"."Script-bismuth"."untileByDragging" = false;
          # "kwinrc"."Script-bismuth"."maximizeSoleTile" = true;
          # "kwinrc"."Script-bismuth"."enableFloatingLayout" = true;
          # "kwinrc"."Script-bismuth"."floatingClass" = "alacrittydropdown,systemsettings,org.kde.plasma.emojier,spectacle,org.freedesktop.impl.portal.desktop.kde";
          # "kwinrc"."Script-bismuth"."floatingTitle" = "Color Picker";
          # "kwinrc"."Script-bismuth"."ignoreClass" = "yakuake,Conky,zoom,org.kde.polkit-kde-authentication-agent-1";
          # "kwinrc"."Script-bismuth"."ignoreTitle" = "Firefox — Sharing Indicator";
          # "kwinrc"."Script-bismuth"."newWindowAsMaster" = true;
          # "kwinrc"."Script-bismuth"."noTileBorder" = true;
          # "kwinrc"."Script-bismuth"."screenGapBottom" = 15;
          # "kwinrc"."Script-bismuth"."screenGapLeft" = 15;
          # "kwinrc"."Script-bismuth"."screenGapRight" = 15;
          # "kwinrc"."Script-bismuth"."screenGapTop" = 15;
          # "kwinrc"."Script-bismuth"."tileLayoutGap" = 15;

          "kcminputrc"."Libinput.1386.914.Wacom Intuos Pro S Finger"."NaturalScroll" = true;
          "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."ClickMethod" = 2;
          "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."NaturalScroll" = true;
          "kcminputrc"."Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."TapToClick" = true;

          "ksmserverrc"."General"."loginMode" = "emptySession";
          "ksmserverrc"."General"."shutdownType" = 2; # Preselect "Shutdown"

          "krunnerrc"."General"."FreeFloating" = true;
          "krunnerrc"."Plugins"."appstreamEnabled" = false;
          "krunnerrc"."Runners.Dictionary"."triggerWord" = "=";
          "krunnerrc"."Runners.Kill Runner"."sorting" = 1;
          "krunnerrc"."Runners.Kill Runner"."triggerWord" = "kill";
          "krunnerrc"."Runners.Kill Runner"."useTriggerWord" = true;
          "krunnerrc"."Runners.krunner_spellcheck"."requireTriggerWord" = true;
          "krunnerrc"."Runners.krunner_spellcheck"."trigger" = "~";

          "kxkbrc"."Layout"."DisplayNames" = "bé,";
          "kxkbrc"."Layout"."LayoutList" = "fr,fr";
          "kxkbrc"."Layout"."Use" = true;
          "kxkbrc"."Layout"."VariantList" = "bepo,us";

          "plasmarc"."Wallpapers"."usersWallpapers" = toString ./wallpapers/nixos.png;

          # Locale
          # REVIEW: maybe setting it up through nix options is sufficient
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
  };
}
