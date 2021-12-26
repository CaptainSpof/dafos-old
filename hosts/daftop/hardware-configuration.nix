# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/457b11b2-d850-4168-9a67-3d5bfe80a4ff";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4d834085-5fe7-4f65-9136-377ccd843f11";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5381-08C2";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
