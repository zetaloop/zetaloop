{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  runtimeShell,
  writeShellApplication,
  curl,
  jq,
  nix-update,
}:

let
  version = "11.2.0.10050";
in
stdenvNoCC.mkDerivation {
  pname = "ilspycmd";
  inherit version;
  src = fetchurl {
    name = "ilspycmd-${version}.zip";
    url = "https://api.nuget.org/v3-flatcontainer/ilspycmd.any/${version}/ilspycmd.any.${version}.nupkg";
    hash = "sha256-1AFfHGOqIhHBxpIyHswo88JBrlhtRB9QxaxQODrQA4g=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/ilspycmd
    cp -r tools/net10.0/any/. $out/lib/ilspycmd/
    printf '#!%s\nexec dotnet "%s" "$@"\n' ${runtimeShell} "$out/lib/ilspycmd/ilspycmd.dll" > $out/bin/ilspycmd
    chmod +x $out/bin/ilspycmd
    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-ilspycmd";
    runtimeInputs = [
      curl
      jq
      nix-update
    ];
    text = ''
      version=$(curl --fail --silent --show-error https://api.nuget.org/v3-flatcontainer/ilspycmd.any/index.json |
        jq -er '[.versions[] | select(test("^[0-9]+(\\.[0-9]+)+$"))] | last')
      nix-update "$UPDATE_NIX_ATTR_PATH" --flake --version="$version"
    '';
  });

  meta = {
    description = "Command-line .NET assembly decompiler";
    homepage = "https://github.com/icsharpcode/ILSpy";
    license = lib.licenses.mit;
    mainProgram = "ilspycmd";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
