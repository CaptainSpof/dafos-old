{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.services.espanso;
in {
  options.profiles.services.espanso = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf cfg.enable {
    # home-manager.users."${config.vars.username}" = {
    #   services.espanso = {
    #     enable = true;

    #     toggle_key = "LEFT_ALT";
    #     settings.matches = [
    #       { # Simple text replacement
    #         trigger = ":espanso";
    #         replace = "Hi there!";
    #       }
    #       { # Dates
    #         trigger = ":date";
    #         replace = "{{mydate}}";
    #         vars = [{
    #           name = "mydate";
    #           type = "date";
    #           params = { format = "%m/%d/%Y"; };
    #         }];
    #       }
    #       { # Shell commands
    #         trigger = ":shell";
    #         replace = "{{output}}";
    #         vars = [{
    #           name = "output";
    #           type = "shell";
    #           params = { cmd = "echo Hello from your shell"; };
    #         }];
    #       }
    #     ];
    #   };
    # };


    environment.systemPackages = with pkgs; [
      espanso
    ];

    systemd.user.services.espanso = {
      enable = true;
      description = "Espanso daemon";
      path = with pkgs; [ espanso coreutils libnotify xclip ];
      serviceConfig = {
        ExecStart = "${pkgs.espanso}/bin/espanso daemon";
        Restart = "always";
        RestartSec = "10";
      };
      after = [ "keyboard-setup.service" ];
      wantedBy = [ "graphical-session.target" ];
    };

    # Config

    # home.configFile = {
    #   "espanso/default.yml".source = "${configDir}/espanso/default.yml";
    #   # "espanso/user/emails.yml".source = "${configDir}/espanso/user/emails.yml";
    # };

  };
}
