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
        system: hash:
        fetchurl {
          url = "https://github.com/zetaloop/overcast/releases/download/v${version}/overcast-${lib.removeSuffix "-linux" system}-unknown-linux-musl";
          inherit hash;
        }
      )
      {
        x86_64-linux = "sha256-0LYZ94HbB/IPmHfoWx0nE99JSAr4zvE+yfGLMFs94p8=";
        aarch64-linux = "sha256-uCdjG/y2q1xiAO8wNYZOFC0a0VNCIluLK8wNc1vjIwM=";
      };
in
stdenvNoCC.mkDerivation {
  pname = "overcast";
  inherit version;
  src = sources.${stdenvNoCC.hostPlatform.system};
  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/overcast"
    echo '{"name":"Nix"}' > "$out/bin/overcast.channel"
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-overcast";
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
    description = "Proxy orchestration across Xray, sing-box, and Mihomo";
    homepage = "https://github.com/zetaloop/overcast";
    license = lib.licenses.mit;
    mainProgram = "overcast";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
