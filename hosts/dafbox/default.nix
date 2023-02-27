{ config, suites, profiles, pkgs, ... }:

{
  imports = suites.desktop ++ [ profiles.desktop.plasma profiles.gaming ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "uas" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "tcp_bbr" "kvm-amd" "uhid" ];
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
    opengl.enable = true;
    sensor.iio.enable = true; # REVIEW: sensor available for dafbox?
  };

  powerManagement.cpuFreqGovernor = "powersave";

  services = {
    openssh = {
      enable = true;
      settings.passwordAuthentication = false;
    };
    fwupd.enable = true; # REVIEW: fwupd available for dafbox?
  };

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

  time.timeZone = "Europe/Paris";
}
