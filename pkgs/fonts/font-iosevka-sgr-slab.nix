{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.0";
in
mkFont {
  pname = "font-iosevka-sgr-slab";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaSlab-${version}.zip";
    hash = "sha256-SBlqoYx755azVYnOdslFqv4/gIW0VyzAH7PRztwQ1TA=";
  };

  meta = {
    description = "Slab-serif monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
