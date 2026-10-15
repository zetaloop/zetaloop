{
  lib,
  fetchurl,
  mkFont,
  nix-update-script,
}:

let
  version = "2.0.0";
in
mkFont {
  pname = "font-space-grotesk";
  inherit version;
  src = fetchurl {
    name = "SpaceGrotesk.ttf";
    url = "https://raw.githubusercontent.com/floriankarsten/space-grotesk/${version}/fonts/ttf/SpaceGrotesk%5Bwght%5D.ttf";
    hash = "sha256-rK1t4fyTQ29cDx9BN3Ue8E8a6jBj5wNlNZcP/PvXn3I=";
  };

  passthru.updateScript = nix-update-script {
    attrPath = "font-space-grotesk";
    extraArgs = [
      "--flake"
      "--url"
      "https://github.com/floriankarsten/space-grotesk"
    ];
  };

  meta = {
    description = "Proportional sans-serif variable font based on Space Mono";
    homepage = "https://github.com/floriankarsten/space-grotesk";
    license = lib.licenses.ofl;
  };
}
