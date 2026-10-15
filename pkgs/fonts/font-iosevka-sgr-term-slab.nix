{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.0";
in
mkFont {
  pname = "font-iosevka-sgr-term-slab";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaTermSlab-${version}.zip";
    hash = "sha256-SoqIYwy0b6S3+c6Q/a+dJvz+/DYOpcWMflHEU1stjjk=";
  };

  meta = {
    description = "Terminal slab-serif monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
