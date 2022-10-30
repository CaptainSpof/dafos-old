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
    acpi
    lm_sensors
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

  profiles.services.espanso.enable = true;
  profiles.hardware.logitech.enable = true;

  home-manager.users."${config.vars.username}" = {
    home.file.".ssh/daf@daftop.pub".text = config.vars.sshPublicKey;
  };
}