channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    dhall
    element-desktop
    rage
    nix-index
    nixpkgs-fmt
    qutebrowser
    starship
    deploy-rs;
}
