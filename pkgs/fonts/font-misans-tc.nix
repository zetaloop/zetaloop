{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "4.009";
in
mkFont {
  pname = "font-misans-tc";
  inherit version;
  src = fetchurl {
    url = "https://hyperos.mi.com/font-download/MiSans_TC.zip";
    hash = "sha256-QXgx8DNgHxc4/vss6RWFhtAUM4Wp3QxM+phbzBbHRDs=";
  };

  fontDirectories = [
    "MiSans TC/可变字体"
  ];

  passthru.fontSource = {
    primary = "MisansTC VF.ttf";
  };

  meta = {
    description = "MiSans Traditional Chinese variable font";
    homepage = "https://hyperos.mi.com/font/";
    license = lib.licenses.unfree;
  };
}
