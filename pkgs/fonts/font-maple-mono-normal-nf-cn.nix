{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "7.9";
in
mkFont {
  pname = "font-maple-mono-normal-nf-cn";
  inherit version;
  src = fetchurl {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMonoNormal-NF-CN.zip";
    hash = "sha256-JK6xTtdW14sRLmaS6gLGaeFq+qDwHnv9uzfS5j+kX6c=";
  };

  meta = {
    description = "Conventional-glyph rounded monospace font with Nerd Font icons and Chinese glyphs";
    homepage = "https://font.subf.dev/";
    license = lib.licenses.ofl;
  };
}
