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
          (
            system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
              packages = {
                cpp2il = pkgs.callPackage ./pkgs/cpp2il.nix { };
                ilspy = pkgs.callPackage ./pkgs/ilspy.nix { };
                ilspycmd = pkgs.callPackage ./pkgs/ilspycmd.nix { };
                xray-knife = pkgs.callPackage ./pkgs/xray-knife.nix { };
              };
            in
            nixpkgs.lib.filterAttrs (
              _: package: nixpkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform package
            ) packages
          );
    };
}
