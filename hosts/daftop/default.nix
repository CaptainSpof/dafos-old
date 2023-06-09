{ self, lib, config, suites, profiles, extraPackages, pkgs, ... }:

{
  imports = suites.laptop ++ [ profiles.desktop.plasma profiles.gaming ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "uas" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      luks.devices."crypted".device = "/dev/disk/by-uuid/2740b97b-a34c-43d5-9a5b-bb86521690ca";
    };
    kernelModules = [ "tcp_bbr" "kvm-amd" "uhid" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    # bitwarden
    google-chrome # TODO: remove when casting to chromecast works
    cifs-utils
    # nomachine-client
    # remmina
    # krdc
    kanata
    extraPackages.devenv
  ];

  # virtualisation.docker.enable = true;

  # services.xrdp.enable = true;
  # services.xrdp.openFirewall = true;

  services.kanata.enable = true;
  services.kanata.keyboards."bepo".devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];

  services.kanata.keyboards."bepo".config = ''
  (deflocalkeys-linux
    <    226
  )

  (defsrc
    grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
    tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
    caps a    s    d    f    g    h    j    k    l    ;    '    ret
    lsft <    z    x    c    v    b    n    m    ,    .    /    rsft
    lctl lmet lalt           spc            ralt rctl)

  (deflayer bepow
    ;; swap è with w
    _     _    _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _    _    _    ]    _    _    _    _    _    _    t    _
    @cap  _    _    _    _    _    _    _    _    _    _    _    _
    _     @nav _    _    _    _    _    _    _    _    _    _    @rsft
    _     _    _              _              _    _)

  (deflayer navigation
    _     _    _    _    _    _    _    _    _    _    _    _    _    _
    _     _    _    _    _    ]    _    _    _    _    _    _    t    _
    @cap  _    _    _    _    _    _    _    _    _    _    _    _
    _     @bep _    _    _    _    _    _    _    _    _    _    @rsft
    _     _    _              _              _    _)

  (defalias
    ;; tap within 100ms for esc, hold more than 100ms for lctl
    cap (tap-hold 100 100 esc lctl)
    rsft (tap-hold 100 100 up rsft)
    nav (layer-switch navigation)
    bep (layer-switch bepow)
  )
'';

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        amdvlk
        libva
        libvdpau-va-gl
      ];
    };
    sensor.iio.enable = true;
  };
  # fonts.optimizeForVeryHighDPI = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = "performance";

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  systemd.services.samba-smbd.enable = true;

  services.fwupd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.dpi = 2; # FIXME: won't build without it

  # TODO: move out
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  networking.firewall.allowedUDPPortRanges = [{ from = 32768; to = 61000; }];   # For Streaming to chromecast

  time.timeZone = "Europe/Paris";

  age.identityPaths = [ "${config.vars.home}/.ssh/daf@daftop.pem" ];

  age.secrets.gh_key = {
    file = "${self}/secrets/gh_key.age";
    path = "${config.vars.home}/.ssh/gh@captainspof.pem";
    owner = "${config.vars.username}";
  };

  profiles = {
    tailscale.enable = true;
    services.espanso.enable = false;
    services.syncthing = {
      enable = true;
      folders = let syncFolderPath = "${config.vars.home}/${config.vars.syncFolder }"; in
                {
                  "Audio" = { path = "${syncFolderPath}/Audio"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
                  "Books" = { path = "${syncFolderPath}/Books"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
                  "Org"   = { path = "${syncFolderPath}/Org";   devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
                  "Share" = { path = "${syncFolderPath}/Share"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
                };
    };

    hardware.logitech.enable = true;

    shell.zellij.enable = true;

    graphical = {
      office.libreoffice.enable = true;
      krita.enable = true;
      audio = {
        enable = true;
        spotify.enable = true;
      };
      video = {
        enable = true;
        recording.enable = true;
        mpv.enable = true;
        youtube-dl.enable = true;
      };
    };
  };

  home-manager.users."${config.vars.username}" = {
    home.sessionVariables = {
      "GDK_SCALE" = 2;
    };

    programs.ssh = {
      matchBlocks = {
        "dafbox" = {
          identityFile = "~/.ssh/daf@daftop.pem";
          identitiesOnly = true;
        };
        "dafpi" = {
          identityFile = "~/.ssh/daf@daftop.pem";
          identitiesOnly = true;
        };
      };
    };

    home.file.".ssh/daf@daftop.pub".text = config.vars.sshPublicKey;
    # FIXME: create symlinks for Books and Org folders
    # home.activation.Books = lib.hm.dag.entryAfter ["writeBoundary"] ''$DRY_RUN_CMD ln -sfn $VERBOSE_ARG ${config.vars.syncFolder}/Books ${config.vars.booksFolder}'';
  };
}
