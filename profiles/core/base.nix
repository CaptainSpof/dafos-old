{ config, pkgs, lib, ... }:

with lib;
{
  boot.cleanTmpDir = true;

  environment = {
    defaultPackages = with pkgs; [
      bind
      binutils
      curl
      dua
      du-dust
      dnsutils
      entr
      fd
      file
      gdu
      git
      highlight
      iputils
      less
      lshw
      moreutils
      nmap
      neovim
      pciutils
      psmisc
      rsync
      unzip
      usbutils
      uutils-coreutils
      wget2
      whois
      xsv
      zip
    ];
    sessionVariables = {
      # These are the defaults, and xdg.enable does set them, but due to load
      # order, they're not set before environment.variables are set, which could
      # cause race conditions.
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_BIN_HOME    = "$HOME/.local/bin";
    };
    variables = {
      ASPELL_CONF = ''
        per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
        personal $XDG_CONFIG_HOME/aspell/en_US.pws;
        repl $XDG_CONFIG_HOME/aspell/en.prepl;
      '';
      EDITOR = "emacs";
      VISUAL = "less";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    };
  };

  hardware.enableAllFirmware = true;

  networking = {
    useDHCP = false;
    firewall.enable = true;
    networkmanager.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      sandbox = true;
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      min-free = 536870912;
      keep-outputs = true;
      keep-derivations = true;
      fallback = true;
      warn-dirty = false;
    };
  };

  # location.provider = "geoclue2";

  programs = {
    fish.enable = true;
    mosh.enable = true;
    mtr.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.extraConfig = "Defaults timestamp_timeout=300";
  };

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MONETARY = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
    LANG = "en_US.UTF-8";
  };

  services = {
    earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
    };

    xserver = {
      layout = "fr";
      xkbVariant = "bepo";
      # TODO: find a way to replace caps lock with ctrl (not swapping). Also, single press should be esc.
      xkbOptions = "caps:escape";
      extraLayouts = {
        fr-dvorak-bepo-intl = {
          description = "bepo intl";
          languages = [ "fr" ];
          symbolsFile = ../hardware/xkb/symbols/fr-dvorak-bepo-intl;
        };
      };
    };
  };

  # activate keyboard layout in console too
  console.useXkbConfig = true;

  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  system.stateVersion = lib.mkDefault "22.11";
}
