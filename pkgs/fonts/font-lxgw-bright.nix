{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "26.10.22";
in
mkFont {
  pname = "font-lxgw-bright";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwBright/releases/download/${version}/LXGWBright.7z";
    hash = "sha256-y9Yy8MDwjxETKcuw/GPN7Ci+icztNTOywA8F6OryN/s=";
  };

  meta = {
    description = "LXGW Bright CJK sans-serif font family";
    homepage = "https://github.com/lxgw/LxgwBright";
    license = lib.licenses.ofl;
  };
}
