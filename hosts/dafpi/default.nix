{ lib, pkgs, config, suites, ... }:
let
  dafpiRootKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi'';
  ipv4 = "192.168.0.33"; # TODO: add dafpi address
in
{
  imports = suites.server;

nixpkgs.overlays = [
  (final: super: {
    makeModulesClosure = x:
      super.makeModulesClosure (x // { allowMissing = true; });
  })
];

boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    # initrd.availableKernelModules = [ "usbhid" "usb_storage" ];

    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      # Allows early (earlier) modesetting for the Raspberry Pi
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
      # Allows early (earlier) modesetting for Allwinner SoCs
      "sun4i_drm"
      "sun8i_drm_hdmi"
      "sun8i_mixer"
    ];

    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
    ];
  };
  # boot.loader.raspberryPi = {
  #   enable = true;
  #   version = 4;
  # };
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  # boot.loader.generic-extlinux-compatible.enable = lib.mkForce false; # incompatible with raspberryPi.enable = true

  # boot = {
  #   loader = {
  #     grub.enable = false;
  #     raspberryPi = {
  #       enable = true;
  #       version = 4;
  #       uboot.enable = true;
  #     };
  #     # generic-extlinux-compatible.enable = true;
  #     # generic-extlinux-compatible.enable = lib.mkForce false; # incompatible with raspberryPi.enable = true
  #   };
  #   tmpOnTmpfs = true;
  #   initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  #   # ttyAMA0 is the serial console broken out to the GPIO
  #   kernelParams = [
  #       "8250.nr_uarts=1"
  #       "console=ttyAMA0,115200"
  #       "console=tty1"
  #       # A lot GUI programs need this, nearly all wayland applications
  #       "cma=128M"
  #   ];
  #   # kernelPackages = pkgs.linuxPackages_rpi4;
  #   kernelPackages = pkgs.linuxPackages_latest;

  #   # kernelPackages = let
  #   #   crossPkgs = import pkgs.path {
  #   #     localSystem.system = "x86_64-linux";
  #   #     crossSystem.system = "aarch64-linux";
  #   #   };
  #   # # in crossPkgs.linuxPackages_5_10;
  #   # in crossPkgs.linuxPackages_rpi4;
  # };

  # These are the filesystems defined on the SD image.
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [ "nofail" ];
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD";
  #     fsType = "ext4";
  #   };
  #   # "/data" = {
  #   #   device = "/dev/disk/by-uuid/"; # TODO: setup disk
  #   #   fsType = "ext4";
  #   #   options = [ "nofail" "X-mount.mkdir" ];
  #   # };
  # };

  # Prevent use of swapspace as much as possible
  boot.kernel.sysctl = { "vm.swappiness" = 0; };

  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 1024;
  #     options = [ "nofail" ];
  #   }
  # ];

  environment.systemPackages = with pkgs; [ git curl bottom ];

  services.journald.extraConfig = ''
    Storage = volatile
    RuntimeMaxFileSize = 10M;
  '';

  networking = {
    useDHCP = false;
    firewall.enable = true;
    networkmanager.enable = true;
    wireless.enable = false;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [ dafpiRootKey ];

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Paris";

  system.stateVersion = "22.11";
}
