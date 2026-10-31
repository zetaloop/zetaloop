{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

let
  version = "0.1.2";
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
          hash = "sha256-35gPJjcDATQl+ST3DOQvEScEs1sP7cGltlxkoiTo2vE=";
        };
        aarch64-linux = {
          arch = "aarch64";
          hash = "sha256-ttOXwj3kdBrWz4EwO4koWAk0BbHAkGaT6obkY5GiOUs=";
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
    updateScript = nix-update-script {
      attrPath = "freedomharbor";
      extraArgs = [
        "--flake"
        "--no-src"
      ]
      ++ lib.concatMap (system: [
        "--subpackage"
        "sources.${system}"
      ]) (builtins.attrNames sources);
    };
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
