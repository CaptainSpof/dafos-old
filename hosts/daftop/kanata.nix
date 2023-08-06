{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    kanata
  ];

  services.kanata.enable = true;
  services.kanata.keyboards."bepo".devices =
    [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

  services.kanata.keyboards."bepo".config = ''
    (deflocalkeys-linux
      <    226
    )

    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft <    z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rctl)

    (deflayer bepow
      ;; swap è with w
      ;; swap à with z
      _     _    _    _    _    _    _    _    _    _    _    _    _    _
      _     _    _    _    _    ]    _    _    _    _    _    z    t    _
      @cap  _    _    _    _    _    _    _    _    _    _    _    _
      _     _    [    _    _    _    _    _    _    _    _    _    @rsft
      _     _    _              _              _    _)

    (defalias
      ;; tap within 100ms for esc, hold more than 100ms for lctl
      cap (tap-hold 100 100 esc lctl)
      rsft (tap-hold 100 100 up rsft)
      bep (layer-switch bepow)
    )
  '';
}
