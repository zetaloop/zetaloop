{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "4.009";
in
mkFont {
  pname = "font-misans";
  inherit version;
  src = fetchurl {
    url = "https://hyperos.mi.com/font-download/MiSans.zip";
    hash = "sha256-tqofyCcDWSJhLfjt825WCbyhxUQeJc1XVyIEVpt7gdk=";
  };

  fontDirectories = [
    "MiSans/可变字体"
  ];

  passthru.fontSource = {
    primary = "MiSansVF.ttf";
  };

  meta = {
    description = "MiSans variable font";
    homepage = "https://hyperos.mi.com/font/";
    license = lib.licenses.unfree;
  };
}
