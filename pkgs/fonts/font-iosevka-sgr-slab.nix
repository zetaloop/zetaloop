{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.1";
in
mkFont {
  pname = "font-iosevka-sgr-slab";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaSlab-${version}.zip";
    hash = "sha256-rK5jLAVXMiVdWXz49CSMWzC8Dw00VAXuyLysRI8ENc0=";
  };

  meta = {
    description = "Slab-serif monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
