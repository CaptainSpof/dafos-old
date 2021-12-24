{ config, lib, pkgs, ... }:

let inherit (lib) fileContents;
in
{
  # a prompt theme, but I can explain why it's a mess (not really) 🦀
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "[⏵](bright-red)[⏵](bright-blue)[⏵](bright-cyan)";
        error_symbol = "[⏵⏵⏵](red)";
      };
    };
  };

}
