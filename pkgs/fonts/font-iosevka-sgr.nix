{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.1";
in
mkFont {
  pname = "font-iosevka-sgr";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-Iosevka-${version}.zip";
    hash = "sha256-JsygIepkbSYQzLTSL75imTn8ORuodXmZ1wI0ugnReyQ=";
  };

  meta = {
    description = "Curly-braced monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
