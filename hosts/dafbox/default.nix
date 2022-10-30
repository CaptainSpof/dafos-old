{ config, suites, profiles, pkgs, ... }:

{
  imports = suites.desktop ++ [ profiles.hercules-ci-agent ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "uas" "usb_storage" "sd_mod" ];
      luks.devices."cryptroot".device = "/dev/disk/by-label/home"; # TODO: setup luks
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

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
      # device = "/dev/disk/by-uuid/EC81-FE28"; # TODO: setup disk device
      fsType = "vfat";
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    sane.enable = true; # REVIEW: checkout sane
    opengl.enable = true;
    sensor.iio.enable = true;
  };

  powerManagement.cpuFreqGovernor = "powersave";

  services = {
    avahi.enable = true;
    fwupd.enable = true; # REVIEW: checkout fwupd
  };

  time.timeZone = "Europe/Paris";

  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = false;
  # };

  # age.identityPaths = [ "${config.vars.home}/.ssh/" ]; # TODO: setup age

  home-manager.users."${config.vars.username}" = {
    # home.file.".ssh/id_ed25519.pub".text = config.vars.sshPublicKey;
    # REVIEW: checkout kanshi
    # services.kanshi.profiles = {
    #   undocked.outputs = [
    #     {
    #       criteria = "eDP-1";
    #       status = "enable";
    #       scale = 1.5;
    #       position = "0,0";
    #     }
    #   ];
    # };
    # REVIEW: checkout unsison
    # services.unison = {
    #   enable = true;
    #   pairs.calibre.roots = [
    #     "${config.vars.home}/books"
    #     "ssh://root@benoni//opt/calibre/data"
    #   ];
    # };
  };
}
