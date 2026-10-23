{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.530";
in
mkFont {
  pname = "font-lxgw-wenkai";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.zip";
    hash = "sha256-FkSj+I+EuWJ8GwDj5BxXUu8b3qDewqw6AkvxB6e9FJ4=";
  };

  meta = {
    description = "LXGW WenKai Chinese handwriting font family";
    homepage = "https://github.com/lxgw/LxgwWenKai";
    license = lib.licenses.ofl;
  };
}
