{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "7.9";
in
mkFont {
  pname = "font-maple-mono-nf-cn";
  inherit version;
  src = fetchurl {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/MapleMono-NF-CN.zip";
    hash = "sha256-r5E7YyKQU0iz9Q5Dl/7cNbOogNte/8znlpADBR3NPpQ=";
  };

  meta = {
    description = "Rounded monospace font with Nerd Font icons and Chinese glyphs";
    homepage = "https://font.subf.dev/";
    license = lib.licenses.ofl;
  };
}
