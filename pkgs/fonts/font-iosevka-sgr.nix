{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.0";
in
mkFont {
  pname = "font-iosevka-sgr";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-Iosevka-${version}.zip";
    hash = "sha256-4MqjX3wYLDNNWN3ij173NWqTXj/CxMK5q+us3pk7ocM=";
  };

  meta = {
    description = "Curly-braced monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
