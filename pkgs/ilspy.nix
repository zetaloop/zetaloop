{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  writeShellApplication,
  curl,
  jq,
  nix-update,
  zlib,
  openssl,
  icu,
  krb5,
  lttng-ust_2_12,
  fontconfig,
  libx11,
  libice,
  libsm,
  libxi,
  libxcursor,
  libxext,
  libxrandr,
  libGL,
  xdg-utils,
}:

let
  version = "11.1.0.9782";
  libraries = [
    stdenv.cc.cc.lib
    zlib
    openssl
    icu
    krb5
    lttng-ust_2_12
    fontconfig
    libx11
    libice
    libsm
    libxi
    libxcursor
    libxext
    libxrandr
    libGL
  ];
in
stdenvNoCC.mkDerivation {
  pname = "ilspy";
  inherit version;
  src = fetchurl {
    url = "https://github.com/icsharpcode/ILSpy/releases/download/v${lib.versions.majorMinor version}/ilspy_${version}-1_amd64.deb";
    hash = "sha256-cmaW1aYhRtr2J9BtJV+jwYJT9jO4YV9IsxOCrojvUUE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = libraries;
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    mv opt/ilspy $out/lib/
    mv usr/share $out/
    makeWrapper $out/lib/ilspy/ILSpy $out/bin/ilspy \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath libraries} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    substituteInPlace $out/share/applications/ilspy.desktop \
      --replace-fail /opt/ilspy/ILSpy $out/bin/ilspy
    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-ilspy";
    runtimeInputs = [
      curl
      jq
      nix-update
    ];
    text = ''
      headers=()
      if [[ -n "''${GITHUB_TOKEN:-}" ]]; then
        headers+=(--header "Authorization: Bearer $GITHUB_TOKEN")
      fi
      version=$(curl --fail --silent --show-error "''${headers[@]}" https://api.github.com/repos/icsharpcode/ILSpy/releases/latest |
        jq -er '.assets[].name | capture("^ilspy_(?<version>[0-9]+(\\.[0-9]+)+)-1_amd64\\.deb$").version')
      nix-update "$UPDATE_NIX_ATTR_PATH" --flake --version="$version"
    '';
  });

  meta = {
    description = ".NET assembly browser and decompiler";
    homepage = "https://github.com/icsharpcode/ILSpy";
    license = lib.licenses.mit;
    mainProgram = "ilspy";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
}
