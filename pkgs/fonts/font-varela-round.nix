{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "3.010";
  revision = "1866b1b967b78211927c48c9835099c33fb85b3b";
  files = {
    "VarelaRound-Regular.ttf" = "sha256-4eR+tm28LdwQZmEzjnEtkXbJ6DxmmoL94VUySCPQOqI=";
  };
in
mkFont {
  pname = "font-varela-round";
  inherit version;
  srcs = lib.mapAttrsToList (
    filename: hash:
    fetchurl {
      name = lib.strings.sanitizeDerivationName filename;
      url = "https://raw.githubusercontent.com/google/fonts/${revision}/ofl/varelaround/${lib.escapeURL filename}";
      inherit hash;
    }
  ) files;

  passthru.fontSource = {
    primary = "VarelaRound-Regular.ttf";
    google = "ofl/varelaround/VarelaRound-Regular.ttf";
  };

  meta = {
    description = "Rounded sans-serif font";
    homepage = "https://fonts.google.com/specimen/Varela+Round";
    license = lib.licenses.ofl;
  };
}
