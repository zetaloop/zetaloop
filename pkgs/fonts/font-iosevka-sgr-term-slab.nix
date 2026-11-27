{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.2";
in
mkFont {
  pname = "font-iosevka-sgr-term-slab";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaTermSlab-${version}.zip";
    hash = "sha256-/rx3Xb6mMOQROXJgQePc+XrY3GOpXfc1RHHijVDdDaw=";
  };

  meta = {
    description = "Terminal slab-serif monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
