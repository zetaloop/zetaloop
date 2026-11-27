{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.2";
in
mkFont {
  pname = "font-iosevka-aile";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-IosevkaAile-${version}.zip";
    hash = "sha256-9neuzh+E8Fn35IlnroQuRJzwL0YRGI5DOU0bIeYju6w=";
  };

  meta = {
    description = "Sans-serif quasi-proportional companion to Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
