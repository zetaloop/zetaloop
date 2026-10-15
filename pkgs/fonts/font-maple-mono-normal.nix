{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "7.9";
in
mkFont {
  pname = "font-maple-mono-normal";
  inherit version;
  src = fetchurl {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMonoNormal-Variable.zip";
    hash = "sha256-1ud9zOHF1oY2OS/U13pCLnRgLDH0Zd5j1eIiMB/F9jc=";
  };

  meta = {
    description = "Conventional-glyph rounded monospace font with ligatures";
    homepage = "https://font.subf.dev/";
    license = lib.licenses.ofl;
  };
}
