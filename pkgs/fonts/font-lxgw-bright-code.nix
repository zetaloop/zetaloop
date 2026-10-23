{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "26.10.22";
in
mkFont {
  pname = "font-lxgw-bright-code";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwBright-Code/releases/download/${version}/LxgwBrightCode.7z";
    hash = "sha256-vKFavIYbV2OgM4uD7YVnU4TgNd8rZOMUlxo7xE5Fq2E=";
  };

  meta = {
    description = "Monospace programming variant of LXGW Bright";
    homepage = "https://github.com/lxgw/LxgwBright-Code";
    license = lib.licenses.ofl;
  };
}
