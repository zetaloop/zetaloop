{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.306";
in
mkFont {
  pname = "font-lxgw-neoxihei";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-vmicx0qKY+M5Nhtv08tG19SZ1aTGWaAioHUluUyXKMg=";
  };

  meta = {
    description = "LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
