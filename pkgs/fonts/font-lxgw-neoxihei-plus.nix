{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.306";
in
mkFont {
  pname = "font-lxgw-neoxihei-plus";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHeiPlus.ttf";
    hash = "sha256-wmoPgVF0MTJx/fRI1D6qSckhFe7fuH9Q2eC/ORMeU/Q=";
  };

  meta = {
    description = "Extended LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
