{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.000";
in
mkFont {
  pname = "font-misans-l3";
  inherit version;
  src = fetchurl {
    url = "https://hyperos.mi.com/font-download/MiSans_L3.zip";
    hash = "sha256-Rn/gFx7J6iHZJaupwDKxp3Wj51bEWPB156LuV1aLDHk=";
  };

  fontDirectories = [
    "MiSans L3"
  ];

  passthru.fontSource = {
    primary = "MiSans L3.ttf";
  };

  meta = {
    description = "MiSans GB 18030-2022 Level 3 rare-character font";
    homepage = "https://hyperos.mi.com/font/rare-word/";
    license = lib.licenses.unfree;
  };
}
