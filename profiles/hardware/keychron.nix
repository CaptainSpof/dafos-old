{ config, ... }:

{
  # boot.extraModprobeConfig = ''
  #   # fix the F* keys on the Keychron K6
  #   options hid_apple fnmode=0
  # '';
  home-manager.users."${config.vars.username}" = {
    # wayland.windowManager.sway.config.input = let k6Conf = {
    #   xkb_layout = "custom-us-keychron";
    #   xkb_options = "caps:escape";
    #   repeat_delay = "200";
    #   repeat_rate = "30";
    # }; in
    #   {
    #     "1452:591:Keychron_K6_Keyboard" = k6Conf;
    #     "1452:591:Keychron_Keychron_K6" = k6Conf;
    #     "1452:591:Keychron_K6" = k6Conf;
    #   };

    home.file.".xkb/symbols/fr-dvorak-bepo-intl".text = ''
    // fr-dvorak-bepo-intl
    partial alphanumeric_keys
    xkb_symbols "bepo-intl" {
                include "fr(bepo)"

                // guillemets
                key <AE01> { type[group1] = "FOUR_LEVEL_SEMIALPHABETIC", [ quotedbl       , 1 , emdash  , doublelowquotemark   ] }; // " 1 — „
                key <AE02> { type[group1] = "FOUR_LEVEL_SEMIALPHABETIC", [ guillemotleft  , 2 , less    , leftdoublequotemark  ] }; // « 2 < “
                key <AE03> { type[group1] = "FOUR_LEVEL_SEMIALPHABETIC", [ guillemotright , 3 , greater , rightdoublequotemark ] }; // » 3 > ”

                // accents morts : circonflexe et grave
                key <AD06> { type[group1] = "FOUR_LEVEL", [ dead_grave , exclam   , VoidSymbol          , exclamdown           ] }; // ` !   ¡
                key <AC02> { type[group1] = "FOUR_LEVEL", [ u          , U        , dead_circumflex     , dead_caron           ] }; // u U ^

                // accents morts en double sous {W} et {Z}
                key <AD11> { type[group1] = "FOUR_LEVEL", [ dead_circumflex , dead_caron    , schwa        , SCHWA             ] }; // ^ ˇ ə Ə
                key <AD12> { type[group1] = "FOUR_LEVEL", [ dead_diaeresis  , dead_abovedot , dead_breve   , VoidSymbol        ] }; // ¨ ¨ ¨

                // W et Z sous la main gauche
                key <AD05> { type[group1] = "FOUR_LEVEL", [ w          , W        , dead_breve          , VoidSymbol           ] }; // w W ˘
                key <AB01> { type[group1] = "FOUR_LEVEL", [ z          , Z        , backslash          , VoidSymbol ] }; // z Z \
    };
    '';
    # home.file.".xkb/symbols/custom-us-keychron".text = ''
    #   default partial alphanumeric_keys
    #   xkb_symbols "custom-altgr-intl-keychron" {
    #       include "custom-us(custom-altgr-intl)"
    #       name[Group1]= "English (US, custom algr-intl-keychron)";

    #       key <ESC> { [ grave, asciitilde, dead_grave, dead_tilde ] };
    #   };
    # '';
  };
}
