{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.011-fix.1";
in
mkFont {
  pname = "font-lxgw-marker-gothic";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwMarkerGothic/releases/download/v${version}/LxgwMarkerGothic-v${version}.zip";
    hash = "sha256-W0gnrlGniHPos78zyhWEckInbJBUFoDsTVrZ/VrlHdQ=";
  };

  fontDirectories = [
    "LxgwMarkerGothic-v${version}/fonts/ttf"
  ];

  meta = {
    description = "LXGW Marker Gothic Chinese display font";
    homepage = "https://github.com/lxgw/LxgwMarkerGothic";
    license = lib.licenses.ofl;
  };
}
