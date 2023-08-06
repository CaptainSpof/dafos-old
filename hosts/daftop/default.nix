{ self, config, suites, profiles, extraPackages, pkgs, ... }:

{
  imports = suites.laptop ++ [
    # profiles
    profiles.desktop.plasma profiles.gaming
    # services
    ./kanata.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "thunderbolt" "nvme" "uas" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      luks.devices."crypted".device =
        "/dev/disk/by-uuid/2740b97b-a34c-43d5-9a5b-bb86521690ca";
    };
    kernelModules = [ "tcp_bbr" "kvm-amd" "uhid" ];
    # kernelPackages = pkgs.linuxPackages_latest;

    # HACK: Revert to kernel 6.4.6 to fix an issue with the laptop keyboard
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_4.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-4ezElu/Eiq8lpmB6S45S1XTW9norCqFmQIfTAdNRXqQ=";
        };
        version = "6.4.6";
        modDirVersion = "6.4.6";
      };
    });

    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    google-chrome # TODO: remove when casting to chromecast works
    cifs-utils
    extraPackages.devenv
    # extraPackages.bazecor
  ];

  # virtualisation.docker.enable = true;

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

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

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

      extraPackages = with pkgs; [ amdvlk libva libvdpau-va-gl ];
    };
    sensor.iio.enable = true;
  };

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

  # TODO: move out
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  networking.firewall.allowedUDPPortRanges = [{
    from = 32768;
    to = 61000;
  }]; # For Streaming to chromecast

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
      folders =
        let syncFolderPath = "${config.vars.home}/${config.vars.syncFolder}";
        in {
          "Audio" = {
            path = "${syncFolderPath}/Audio";
            devices = [ "dafbox" "daf-old-top" "dafphone" ];
          };
          "Books" = {
            path = "${syncFolderPath}/Books";
            devices = [ "dafbox" "daf-old-top" "dafphone" ];
          };
          "Org" = {
            path = "${syncFolderPath}/Org";
            devices = [ "dafbox" "daf-old-top" "dafphone" ];
          };
          "Share" = {
            path = "${syncFolderPath}/Share";
            devices = [ "dafbox" "daf-old-top" "dafphone" ];
          };
        };
    };

    hardware.logitech.enable = true;

    shell.tmux.enable = false;
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
