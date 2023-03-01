{ config, self, suites, profiles, pkgs, ... }:

let
  daftopKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7YCmRYdXWhNTGWWklNYrQD5gUBTFhvzNiis5oD1YwV daf@daftop'';
  daftopRootKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+WUE0u1TwkPF2yhetXKVPSpZrfxTW72hSzBcsL0Z8z root@daftop'';
  ipv4 = "192.168.0.31"; # TODO: add dafbox address
in
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
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl.enable = true;
    sensor.iio.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd.services.samba-smbd.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  users.users."${config.vars.username}".openssh.authorizedKeys.keys = [
    config.vars.sshPublicKey
    daftopRootKey
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    config.vars.sshPublicKey
    daftopRootKey
  ];

  services.fwupd.enable = true; # REVIEW: fwupd available for dafbox?

  services.jellyfin = {
    enable = true;
    user = "daf";
    openFirewall = true;
  };

  profiles = {
    tailscale.enable = true;
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
      };
    };
  };

  time.timeZone = "Europe/Paris";

  age.secrets.gh_key = {
    file = "${self}/secrets/gh_key.age";
    path = "${config.vars.home}/.ssh/gh@captainspof.pem";
    owner = "${config.vars.username}";
  };
}
