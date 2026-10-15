{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "6.2";
in
mkFont {
  pname = "font-fira-code";
  inherit version;
  src = fetchurl {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/Fira_Code_v${version}.zip";
    hash = "sha256-CUmRW6jrJNif2T0Qp/9iP0KDDXxf/D7L+WDk7K0+Pnk=";
  };

  fontDirectories = [
    "ttf"
  ];

  meta = {
    description = "Monospaced font with programming ligatures";
    homepage = "https://github.com/tonsky/FiraCode";
    license = lib.licenses.ofl;
  };
}
