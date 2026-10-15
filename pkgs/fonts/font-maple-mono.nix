{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "7.9";
in
mkFont {
  pname = "font-maple-mono";
  inherit version;
  src = fetchurl {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMono-Variable.zip";
    hash = "sha256-ueV2d8xOwGnOF4vZZdZs0UvSbBLjfYnXhv+Vkzm/jJM=";
  };

  meta = {
    description = "Rounded monospace font with ligatures";
    homepage = "https://font.subf.dev/";
    license = lib.licenses.ofl;
  };
}
