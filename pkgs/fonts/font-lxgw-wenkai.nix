{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.522";
in
mkFont {
  pname = "font-lxgw-wenkai";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.zip";
    hash = "sha256-O1liBUI9g4zNCWW/osfotuvLnZKE4YCeI0rR1fRBre8=";
  };

  meta = {
    description = "LXGW WenKai Chinese handwriting font family";
    homepage = "https://github.com/lxgw/LxgwWenKai";
    license = lib.licenses.ofl;
  };
}
