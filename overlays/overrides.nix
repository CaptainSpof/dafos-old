channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    deploy-rs
    dhall
    element-desktop
    nix-index
    nixpkgs-fmt
    qutebrowser
    rage
    starship;
}
