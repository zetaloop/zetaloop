{
  lib,
  stdenvNoCC,
  fetchurl,
  nix,
  nix-update,
  writeShellApplication,
}:

let
  version = "0.1.3";
  sources =
    lib.mapAttrs
      (
        _: source:
        fetchurl {
          inherit version;
          name = "freedomharbor-linux-${source.arch}.tar.gz";
          url = "https://github.com/zetaloop/FreedomHarbor/releases/download/v${version}/freedomharbor-linux-${source.arch}.tar.gz";
          inherit (source) hash;
        }
      )
      {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-5/uejOChsMTFCzxaM1OE7wqkZwN30BIjlNstFxQrBLk=";
        };
        aarch64-linux = {
          arch = "aarch64";
          hash = "sha256-+kkOGdXqakgigkNyEeDTuacgnQ9njBMW1HLnipdLYKM=";
        };
      };
in
stdenvNoCC.mkDerivation {
  pname = "freedomharbor";
  inherit version;
  src = sources.${stdenvNoCC.hostPlatform.system};

  installPhase = ''
    runHook preInstall
    install -Dm755 freedomharbor $out/bin/freedomharbor
    install -Dm644 LICENSE $out/share/licenses/freedomharbor/LICENSE
    mkdir -p $out/share/doc/freedomharbor
    cp -r README.md docs examples $out/share/doc/freedomharbor/
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-freedomharbor";
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
    description = "DPI evasion and traffic normalization for Linux gateways";
    homepage = "https://github.com/zetaloop/FreedomHarbor";
    license = lib.licenses.mit;
    mainProgram = "freedomharbor";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
