{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "3.603";
  revision = "73086f05f20695bb8ea7e607781dc6ffe316fdbc";
  files = {
    "Mulish-Italic[wght].ttf" = "sha256-T01fl7UwUAIy2dSHEBuCg4QBaNz+e4uaKFr2Xw+oqqs=";
    "Mulish[wght].ttf" = "sha256-APEQV5YpGi/doReg/H8l2OaPgBDNuzSkEfYLO9V3F6w=";
  };
in
mkFont {
  pname = "font-mulish";
  inherit version;
  srcs = lib.mapAttrsToList (
    filename: hash:
    fetchurl {
      name = lib.strings.sanitizeDerivationName filename;
      url = "https://raw.githubusercontent.com/google/fonts/${revision}/ofl/mulish/${lib.escapeURL filename}";
      inherit hash;
    }
  ) files;

  passthru.fontSource = {
    primary = "Mulish[wght].ttf";
    google = "ofl/mulish";
  };

  meta = {
    description = "Minimalist sans-serif variable font";
    homepage = "https://fonts.google.com/specimen/Mulish";
    license = lib.licenses.ofl;
  };
}
