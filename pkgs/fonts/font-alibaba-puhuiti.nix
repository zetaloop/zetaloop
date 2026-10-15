{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "3.01";
  headers = {
    Referer = "https://www.alibabafonts.com/";
  };
in
mkFont {
  pname = "font-alibaba-puhuiti";
  inherit version;
  src = fetchurl {
    url = "https://fonts.alibabadesign.com/AlibabaPuHuiTi-3.zip";
    hash = "sha256-8l9zC2p2YbzVuXZNyY8F06wl7ncZd88Esx7V+6n0lqc=";
    curlOptsList = lib.concatLists (
      lib.mapAttrsToList (name: value: [
        "--header"
        "${name}: ${value}"
      ]) headers
    );
  };

  passthru.fontSource = {
    primary = "AlibabaPuHuiTi-3-55-Regular.ttf";
    inherit headers;
  };

  meta = {
    description = "Alibaba PuHuiTi Chinese sans-serif font family";
    homepage = "https://www.alibabafonts.com/";
    license = lib.licenses.unfree;
  };
}
