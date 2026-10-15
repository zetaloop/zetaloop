{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.0";
in
mkFont {
  pname = "font-iosevka-aile";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-IosevkaAile-${version}.zip";
    hash = "sha256-zJA/4uZ0cMyWsRCFpQ7kqFCNkigwXG/oTaxF4rtW2ks=";
  };

  meta = {
    description = "Sans-serif quasi-proportional companion to Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
