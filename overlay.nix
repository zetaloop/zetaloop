final: prev: {
  nix-update = prev.nix-update.overrideAttrs (old: {
    # shortcut: Nix 2.35 no longer copies `nix flake metadata` paths to the store, drop after Mic92/nix-update#687
    patches = old.patches or [ ] ++ [ ./patches/nix-update.patch ];
  });
}
