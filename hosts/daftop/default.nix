{ self, lib, config, suites, profiles, pkgs, ... }:

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

  # TODO: move out
  services.acpid.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    bitwarden
    tpacpi-bat
  ];

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
      powerOnBoot = false;
    };
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl.enable = true;
    sensor.iio.enable = true;
    video.hidpi.enable = lib.mkDefault true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    fwupd.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };

  time.timeZone = "Europe/Paris";

  age.identityPaths = [ "${config.vars.home}/.ssh/daf@daftop.pem" ];

  profiles = {
    services.espanso.enable = false;
    services.syncthing = {
      enable = true;
      folders = let syncFolderPath = "${config.vars.home}/${config.vars.syncFolder }"; in
        {
          "Audio" = { path = "${syncFolderPath}/Audio"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
          "Books" = { path = "${syncFolderPath}/Books"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
          "Org" = { path = "${syncFolderPath}/Org"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
          "Share" = { path = "${syncFolderPath}/Share"; devices = [ "dafbox" "daf-old-top" "dafphone" ]; };
        };
    };

    hardware.logitech.enable = true;

    graphical = {
      krita.enable = true;
      audio = {
        enable = true;
        spotify.enable = true;
      };
      chats.slack.enable = true;
      video = {
        enable = true;
        recording.enable = true;
      };
    };
  };

  home-manager.users."${config.vars.username}" = {

    home.sessionVariables = {
      "GDK_SCALE" = 2;
    };

    home.file.".ssh/daf@daftop.pub".text = config.vars.sshPublicKey;
    # FIXME: create symlinks for Books and Org folders
    # home.activation.Books = lib.hm.dag.entryAfter ["writeBoundary"] ''$DRY_RUN_CMD ln -sfn $VERBOSE_ARG ${config.vars.syncFolder}/Books ${config.vars.booksFolder}'';
  };
}
