{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  writeShellApplication,
  curl,
  jq,
  nix,
  nix-update,
  zlib,
  openssl,
  icu,
  krb5,
  lttng-ust_2_12,
}:

let
  version = "2022.1.0-pre-release.21";
  sources =
    lib.mapAttrs
      (
        _: source:
        fetchurl {
          inherit version;
          name = "Cpp2IL-${version}-${source.arch}";
          url = "https://github.com/SamboyCoding/Cpp2IL/releases/download/${version}/Cpp2IL-${version}-${source.arch}";
          inherit (source) hash;
        }
      )
      {
        x86_64-linux = {
          arch = "Linux";
          hash = "sha256-UmmY5ZPFLAKcWmIVxcbJ+dljcGv8QJ/J/4CpXExQA0k=";
        };
        aarch64-linux = {
          arch = "Linux-ARM64";
          hash = "sha256-LY52sR9S/YVEDsYKv4fVw0VepU9RBOCvUdoVukRAhxs=";
        };
      };
  libraries = [
    stdenv.cc.cc.lib
    zlib
    openssl
    icu
    krb5
    lttng-ust_2_12
  ];
in
stdenvNoCC.mkDerivation {
  pname = "cpp2il";
  inherit version;
  src = sources.${stdenvNoCC.hostPlatform.system};

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = libraries;
  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/cpp2il
    wrapProgram $out/bin/cpp2il --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath libraries}
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-cpp2il";
      runtimeInputs = [
        curl
        jq
        nix
        nix-update
      ];
      text = ''
        headers=()
        if [[ -n "''${GITHUB_TOKEN:-}" ]]; then
          headers+=(--header "Authorization: Bearer $GITHUB_TOKEN")
        fi
        versions=$(curl --fail --silent --show-error "''${headers[@]}" https://api.github.com/repos/SamboyCoding/Cpp2IL/releases |
          jq -ec '[.[] | select(.draft | not) | .tag_name | select(test("^[0-9]+(\\.[0-9]+)+(-pre-release\\.[0-9]+)?$"))] | tojson')
        version=$(nix eval --raw --expr "builtins.head (builtins.sort (a: b: builtins.compareVersions a b > 0) (builtins.fromJSON $versions))")
        [[ $version == "$UPDATE_NIX_OLD_VERSION" ]] && exit 0
        nix-update "$UPDATE_NIX_ATTR_PATH" --flake --version="$version" --no-src ${
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
    description = "Reverse Unity's IL2CPP build process";
    homepage = "https://github.com/SamboyCoding/Cpp2IL";
    license = lib.licenses.mit;
    mainProgram = "cpp2il";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
