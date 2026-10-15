{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.305";
in
mkFont {
  pname = "font-lxgw-neoxihei-plus";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHeiPlus.ttf";
    hash = "sha256-aCYa3UB715XAQP5mK34h5admrMmlNMOTRz+Klyxe0iQ=";
  };

  meta = {
    description = "Extended LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
