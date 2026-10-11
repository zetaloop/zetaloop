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
}:

let
  version = "11.3.0";
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
          hash = "sha256-rYA/4rDPzssdh0I+/6mKNq6VWH1Wo3dEaoTjqBG3+Ds=";
        };
        aarch64-linux = {
          arch = "linux-arm64-v8a";
          hash = "sha256-18XjUQZeywlJptrF0IkT6W+vJdLgSTYRLXkH2Rh+OZg=";
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
