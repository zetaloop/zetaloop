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
  nix-update-script,
}:

let
  version = "11.4.0";
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
          hash = "sha256-ISUzcEPMRYbHtxCqBlWxtxgKLx5Gk7PstcNzUwqMD30=";
        };
        aarch64-linux = {
          arch = "linux-arm64-v8a";
          hash = "sha256-XwOgWr1Ny4YE0fhpO08d7s9ZG1mZNzP9IIsCzb5Arl4=";
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
    updateScript = nix-update-script {
      attrPath = "xray-knife";
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
    description = "Manage, test, and use Xray and sing-box proxy configurations";
    homepage = "https://github.com/lilendian0x00/xray-knife";
    license = lib.licenses.mit;
    mainProgram = "xray-knife";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
