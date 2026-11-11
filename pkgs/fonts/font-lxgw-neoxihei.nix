{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.309";
in
mkFont {
  pname = "font-lxgw-neoxihei";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-LpOFF9G7LSPEUoKbrGwoMKRXfZ7rutIkRcXEGR60MI8=";
  };

  meta = {
    description = "LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
