{ config, suites, profiles, pkgs, ... }:

{
  imports = suites.desktop;

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
    opengl.enable = true;
    sensor.iio.enable = true; # REVIEW: sensor available for dafbox?
  };

  powerManagement.cpuFreqGovernor = "powersave";

  services = {
    avahi.enable = true;
    fwupd.enable = true; # REVIEW: fwupd available for dafbox?
  };

  time.timeZone = "Europe/Paris";
}
