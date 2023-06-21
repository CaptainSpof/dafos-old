final: prev: {
  logiops = prev.logiops.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "PixlOne";
      version = "0.3.2";
      repo = "logiops";
      rev = "5767aac362d0ff148b690a61690b69b7a79e382f";
      sha256 = "sha256-vFco1pbUZZU4AM64xScX6ez32Ur3ypyocRVDc/sMwbQ=";
    };
  });
}
