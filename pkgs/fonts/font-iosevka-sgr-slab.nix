{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.2";
in
mkFont {
  pname = "font-iosevka-sgr-slab";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaSlab-${version}.zip";
    hash = "sha256-4NshJXumpd4NyJ45VKYI1hQk9Kats7m44z/jySLYGuQ=";
  };

  meta = {
    description = "Slab-serif monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
