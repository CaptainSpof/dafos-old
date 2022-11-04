final: prev: {
  lightly = prev.libsForQt5.lightly.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "boehs";
      repo = "lightly";
      rev = "0037670ac3a187b0c65b9324caaf46d94e0faa5e";
      sha256 = "sha256-t3xmPuqmDxPMpdDqPiy8P5bMUW46cYfWJMS9TnAD3bs=";
    };
  });
}
