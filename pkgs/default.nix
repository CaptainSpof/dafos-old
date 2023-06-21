final: prev: with prev;
{
    # keep sources this first
    sources = prev.callPackage (import ./_sources/generated.nix) { };
    # then, call packages with `final.callPackage`

    polonium = callPackage ./polonium.nix { };
}
