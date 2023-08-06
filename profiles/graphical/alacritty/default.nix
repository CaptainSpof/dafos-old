{ config, pkgs, ... }:

{
  home-manager.users."${config.vars.username}" = {
    programs.alacritty = {
      enable = true;
      settings = {
        shell = { program = "${pkgs.zellij}/bin/zellij"; };
        tabspace = 4;
        mouse = { hide_cursor_typing = true; };
        window = {
          opacity = 1;
          decorations = "none";
          padding = { x = 8; y = 8; };
          dynamic_padding = true;
          # set default dimensions that will be used by alacrittydropdown
          dimensions.columns = 120;
          dimensions.lines = 40;
        };
        font = {
          size = 12.0;
          normal = { family = "Inconsolata Nerd Font"; };
        };
        colors = {
          primary = {
            background = "#1b2b34";
            foreground = "#d8dee9";
          };

          # (Optional) Bright and Dim foreground colors
          #
          # The dimmed foreground color is calculated automatically if it is not present.
          # If the bright foreground color is not set, or `draw_bold_text_with_bright_colors`
          # is `false`, the normal foreground color will be used.
          #
          # dim_foreground = "#9a9a9a"
          # bright_foreground = "#ffffff"

          # Colors the cursor will use if `custom_cursor_colors` is true
          cursor = {
            text = "#000000";
            cursor = "#ffffff";
          };

          # Normal colors
          normal = {
            black = "#343d46";
            red = "#ec5f67";
            green = "#99c794";
            yellow = "#fac863";
            blue = "#6699cc";
            magenta = "#c594c5";
            cyan = "#5fb3b3";
            white = "#cdd3de";
          };

          # Bright colors
          bright = {
            black = "#343d46";
            red = "#ec5f67";
            green = "#99c794";
            yellow = "#fac863";
            blue = "#6699cc";
            magenta = "#c594c5";
            cyan = "#5fb3b3";
            white = "#cdd3de";
          };

          # Dim colors (Optional)
          dim = {
            black = "#333333";
            red = "#f2777a";
            green = "#99cc99";
            yellow = "#ffcc66";
            blue = "#6699cc";
            magenta = "#cc99cc";
            cyan = "#66cccc";
            white = "#dddddd";
          };
        };
      };
    };
    home.file.".config/alacritty/alacrittydropdown.sh" = {
      source = ./alacrittydropdown.sh;
    };
  };
}
