{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.522";
in
mkFont {
  pname = "font-lxgw-wenkai-lite";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai-Lite/releases/download/v${version}/lxgw-wenkai-lite-v${version}.zip";
    hash = "sha256-fIbO7sVPLKqLZ0sqeb2C9EF4Fat8czD4D+3nbuTJ6gs=";
  };

  meta = {
    description = "LXGW WenKai Lite Chinese handwriting font family";
    homepage = "https://github.com/lxgw/LxgwWenKai-Lite";
    license = lib.licenses.ofl;
  };
}
