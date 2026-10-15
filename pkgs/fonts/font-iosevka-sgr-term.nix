{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "34.9.0";
in
mkFont {
  pname = "font-iosevka-sgr-term";
  inherit version;
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaTerm-${version}.zip";
    hash = "sha256-2ronD8+MRxv3o9JwVekNvmTqESBdRPHsEGGJLQibvpI=";
  };

  meta = {
    description = "Terminal monospace variant of Iosevka";
    homepage = "https://typeof.net/Iosevka/";
    license = lib.licenses.ofl;
  };
}
