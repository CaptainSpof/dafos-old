{ lib, pkgs, config, suites, ... }:
let
  dafpiRootKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGBJKhslXRQ4Bt8Nu3/YK799UsUpzpP6sDVkVw36nLR daf@dafpi'';
  ipv4 = "192.168.0.33"; # TODO: add dafpi address
in
{
  imports = suites.server;

# nixpkgs.overlays = [
#   (final: super: {
#     makeModulesClosure = x:
#       super.makeModulesClosure (x // { allowMissing = true; });
#   })
# ];

  boot = {
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
        # uboot.enable = true;
      };
      generic-extlinux-compatible.enable = lib.mkForce false; # incompatible with raspberryPi.enable = true
    };
    kernelParams = [ "cma=128M" ];
    kernelPackages = pkgs.linuxPackages_rpi4;

    # kernelPackages = let
    #   crossPkgs = import pkgs.path {
    #     localSystem.system = "x86_64-linux";
    #     crossSystem.system = "aarch64-linux";
    #   };
    # # in crossPkgs.linuxPackages_5_10;
    # in crossPkgs.linuxPackages_rpi4;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/data" = {
      device = "/dev/disk/by-uuid/"; # TODO: setup disk
      fsType = "ext4";
      options = [ "nofail" "X-mount.mkdir" ];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
      options = [ "nofail" ];
    }
  ];

  environment.systemPackages = with pkgs; [ kakoune git curl bottom ];

  services.journald.extraConfig = ''
    Storage = volatile
    RuntimeMaxFileSize = 10M;
  '';

  networking = {
    useDHCP = false;
    defaultGateway = {
      address = "192.168.0.1";
      interface = "eth0";
    };
    nameservers = [ "1.1.1.1" ];
    interfaces.eth0 = {
      ipv4.addresses = [
        { address = ipv4; prefixLength = 24; }
      ];
      useDHCP = false;
    };
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
