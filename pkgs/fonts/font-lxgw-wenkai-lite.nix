{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.530";
in
mkFont {
  pname = "font-lxgw-wenkai-lite";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwWenKai-Lite/releases/download/v${version}/lxgw-wenkai-lite-v${version}.zip";
    hash = "sha256-f6CE39t282pAwYPbtQy10vkrLqJlU0VJiOCMiJ+O1fo=";
  };

  meta = {
    description = "LXGW WenKai Lite Chinese handwriting font family";
    homepage = "https://github.com/lxgw/LxgwWenKai-Lite";
    license = lib.licenses.ofl;
  };
}
