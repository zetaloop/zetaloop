{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.308";
in
mkFont {
  pname = "font-lxgw-neoxihei";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-gEFdNmbZ9Rz0Ls+CxTUEiOaz8oKrRqO5Dcql4hJWTsw=";
  };

  meta = {
    description = "LXGW Neo XiHei Chinese sans-serif font";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = lib.licenses.ipa;
  };
}
