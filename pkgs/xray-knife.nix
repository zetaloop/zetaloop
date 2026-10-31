{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeWrapper,
  iproute2,
  iptables,
  nftables,
  util-linux,
  nix,
  nix-update,
  writeShellApplication,
}:

let
  version = "11.5.0";
  sources =
    lib.mapAttrs
      (
        _: source:
        fetchurl {
          inherit version;
          name = "Xray-knife-${source.arch}.zip";
          url = "https://github.com/lilendian0x00/xray-knife/releases/download/v${version}/Xray-knife-${source.arch}.zip";
          inherit (source) hash;
        }
      )
      {
        x86_64-linux = {
          arch = "linux-64";
          hash = "sha256-aWRE2679AKylSEBLhgSKKeqa3omu9FSmKFQcHp14mok=";
        };
        aarch64-linux = {
          arch = "linux-arm64-v8a";
          hash = "sha256-Jr9zYTYPjGxpkaa3fzTC1Rcq5bGvtEWldjLw9toeau4=";
        };
      };
in
stdenvNoCC.mkDerivation {
  pname = "xray-knife";
  inherit version;
  src = sources.${stdenvNoCC.hostPlatform.system};

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 xray-knife $out/bin/xray-knife
    install -Dm644 LICENSE $out/share/licenses/xray-knife/LICENSE
    wrapProgram $out/bin/xray-knife --suffix PATH : ${
      lib.makeBinPath [
        iproute2
        iptables
        nftables
        util-linux
      ]
    }
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-xray-knife";
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
    description = "Manage, test, and use Xray and sing-box proxy configurations";
    homepage = "https://github.com/lilendian0x00/xray-knife";
    license = lib.licenses.mit;
    mainProgram = "xray-knife";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
