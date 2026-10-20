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
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              mkFont = pkgs.callPackage ./pkgs/font.nix { };
              fonts =
                nixpkgs.lib.mapAttrs'
                  (
                    filename: _:
                    nixpkgs.lib.nameValuePair (nixpkgs.lib.removeSuffix ".nix" filename) (
                      pkgs.callPackage (./pkgs/fonts + "/${filename}") { inherit mkFont; }
                    )
                  )
                  (
                    nixpkgs.lib.filterAttrs (
                      filename: type: type == "regular" && nixpkgs.lib.hasSuffix ".nix" filename
                    ) (builtins.readDir ./pkgs/fonts)
                  );
              packages = fonts // {
                cpp2il = pkgs.callPackage ./pkgs/cpp2il.nix { };
                font-all = pkgs.symlinkJoin {
                  name = "font-all";
                  paths = builtins.attrValues fonts;
                };
                freedomharbor = pkgs.callPackage ./pkgs/freedomharbor.nix { };
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
