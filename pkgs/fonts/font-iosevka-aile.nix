{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.1";
in
mkFont {
  pname = "font-iosevka-aile";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-IosevkaAile-${version}.zip";
    hash = "sha256-I+KF3Qli6ie31xGF/ncARjyGGqnvETU7w9IAq4dk1d0=";
  };

  meta = {
    description = "Sans-serif quasi-proportional companion to Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
