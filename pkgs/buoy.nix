{
  lib,
  stdenvNoCC,
  fetchurl,
  nix,
  nix-update,
  writeShellApplication,
}:

let
  version = "0.1.0";
  sources =
    lib.mapAttrs
      (
        _: source:
        fetchurl {
          inherit version;
          name = "buoy-linux-${source.arch}.tar.gz";
          url = "https://github.com/zetaloop/Buoy/releases/download/v${version}/buoy-linux-${source.arch}.tar.gz";
          inherit (source) hash;
        }
      )
      {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-faDDp/X1oDOw5Ey2yi32TsE5VQZXd1Fp2RXwK8Ro9Q0=";
        };
        aarch64-linux = {
          arch = "aarch64";
          hash = "sha256-fFvl8+Q/L5f65dpxfAc2Fqs7AS/UylKCve86jqdA/cg=";
        };
      };
in
stdenvNoCC.mkDerivation {
  pname = "buoy";
  inherit version;
  src = sources.${stdenvNoCC.hostPlatform.system};

  installPhase = ''
    runHook preInstall
    install -Dm755 buoy $out/bin/buoy
    install -Dm644 LICENSE $out/share/licenses/buoy/LICENSE
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-buoy";
      runtimeInputs = [
        nix
        nix-update
      ];
      text = ''
        nix-update "$UPDATE_NIX_ATTR_PATH" --flake --no-src
        version=$(nix eval --raw ".#$UPDATE_NIX_ATTR_PATH.version")
        [[ $version == "$UPDATE_NIX_OLD_VERSION" ]] && exit 0
        nix-update "$UPDATE_NIX_ATTR_PATH" --flake --no-src --version=skip ${
          lib.escapeShellArgs (
            lib.concatMap (system: [
              "--subpackage"
              "sources.${system}"
            ]) (builtins.attrNames sources)
          )
        }
      '';
    });
  };

  meta = {
    description = "Live gateway status on a small SSD130x OLED display";
    homepage = "https://github.com/zetaloop/Buoy";
    license = lib.licenses.mit;
    mainProgram = "buoy";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
