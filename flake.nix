{
  description = "Zetaloop packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    {
      packages =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (system: {
            xray-knife = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/xray-knife.nix { };
          });
    };
}
