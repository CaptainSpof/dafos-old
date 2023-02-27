{ config, options, pkgs, lib, ... }:

with lib;
let cfg = config.profiles.services.syncthing;
    daftop.id        = "IAMUXFU-NW7O4RH-QGYSUBR-RMBHSOV-UG4SXQL-MSOWGOG-2MNOBDE-26QLVAQ";
    daf-old-top.id   = "KQZGBVD-2EPBFMT-MPLIPPX-3BX5YZJ-TMKBFRF-ILXVVBR-RRJ35VN-T3ZYLQE";
    dafbox.id        = "62Z4SAR-NEWLJR7-6HAGVEX-GWPNSTP-IOGWUF6-ODAQJ4Q-3BAVWTF-VDJGYA7";
    dafphone.id      = "2RY63N4-F3XSFO7-CUZRJD2-KEIM4QT-AAQINLH-QLLPJ2Z-CC7MN3A-J5YDQA3";
    daf-old-phone.id = "G3MQBMD-VN542WA-6V5EEGT-FBJXK5K-NREP2CU-WA4LFMV-NW3SIED-CRNNWQ2";
    dafpi.id         = "6LSQT5W-CDVRC2U-OYU77MY-XQGUN7H-NWRMZPY-CJ6ETAZ-4XSHR2E-5ADGGQI";

in {
  options.profiles.services.syncthing = {
    enable = mkOption { type = types.bool; default = true; };

    # FIXME/HACK: how to 'inherit' types in nix?
    # I want hosts to be able to pass folders configurations to this profile
    # (or maybe this needs a module?) nixpkgs already defines a `folders` option.
    # I would like to reuse it. For now, I extracted the parts that I use.
    folders = mkOption {
      default = {};
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          path = mkOption {
            type = types.str;
            default = name;
          };

          id = mkOption {
            type = types.str;
            default = name;
          };

          label = mkOption {
            type = types.str;
            default = name;
          };

          devices = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
      }));
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = rec {
      enable = true;
      devices = {
        inherit daftop;
        inherit daf-old-top;
        inherit dafbox;
        inherit dafphone;
        inherit dafpi;
      };
      openDefaultPorts = true;
      user = config.vars.username;
      configDir = "${config.vars.configHome}/syncthing";
      dataDir = "${config.vars.home}/.local/share/syncthing";
      folders = cfg.folders;
    };
  };
}
