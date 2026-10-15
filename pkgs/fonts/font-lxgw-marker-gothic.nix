{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.004";
in
mkFont {
  pname = "font-lxgw-marker-gothic";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwMarkerGothic/releases/download/v${version}/LxgwMarkerGothic-v${version}.zip";
    hash = "sha256-SjDIIgBmTVNm7Y74Iu4gha0Wx2eGI5a5a4kk/ZQpeqY=";
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
