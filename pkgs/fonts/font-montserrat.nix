{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "9.000";
in
mkFont {
  pname = "font-montserrat";
  inherit version;
  src = fetchurl {
    url = "https://github.com/JulietaUla/Montserrat/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-mRs/lxxlCBx4D6FWRaAwvfniHuhzS59gEGOLg7rh/4M=";
  };

  fontDirectories = [
    "Montserrat-${version}/fonts/variable"
    "Montserrat-${version}/fonts-alternates/variable"
  ];

  meta = {
    description = "Geometric sans-serif variable fonts with Montserrat Alternates";
    homepage = "https://github.com/JulietaUla/Montserrat";
    license = lib.licenses.ofl;
  };
}
