final: prev: {
  klassy = prev.libsForQt5.breeze-qt5.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "paulmcauley";
      repo = "klassy";
      rev = "15bcf1f273c7070bed2acd49fae8cca26ad1d1bc";
      sha256 = "sha256-rhaWuMBuwbeJSDulisqGFPYm3XTVyMGQd0WYtf64KMw=";
    };
  });
}
