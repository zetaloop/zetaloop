{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "5.528";
in
mkFont {
  pname = "font-lxgw-bright";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwBright/releases/download/v${version}/LXGWBright.7z";
    hash = "sha256-pHa6liDc4Pu6dSL+V47VzHuhRRg2NhKvWD/gfqM5c+o=";
  };

  meta = {
    description = "LXGW Bright CJK sans-serif font family";
    homepage = "https://github.com/lxgw/LxgwBright";
    license = lib.licenses.ofl;
  };
}
