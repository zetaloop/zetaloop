{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.1";
in
mkFont {
  pname = "font-iosevka-etoile";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-IosevkaEtoile-${version}.zip";
    hash = "sha256-IvBRMiwnCBIpUoVqr2vwZ/onJH+q0JkEqmBn69LTN4U=";
  };

  meta = {
    description = "Slab-serif quasi-proportional companion to Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
