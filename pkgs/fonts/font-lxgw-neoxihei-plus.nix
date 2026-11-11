{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.309";
in
mkFont {
  pname = "font-lxgw-neoxihei-plus";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHeiPlus.ttf";
    hash = "sha256-ho1Te75+qDo1okn8qClynq2TN4KODEcJ8pviJ3wRckM=";
  };

  meta = {
    description = "Extended LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
