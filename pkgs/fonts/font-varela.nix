{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.000";
  revision = "90abd17b4f97671435798b6147b698aa9087612f";
  files = {
    "Varela-Regular.ttf" = "sha256-h88N3VDNKXzW+s+qyL9Zv40LGjuLZhmVe6COcgQ9GJY=";
  };
in
mkFont {
  pname = "font-varela";
  inherit version;
  srcs = lib.mapAttrsToList (
    filename: hash:
    fetchurl {
      name = lib.strings.sanitizeDerivationName filename;
      url = "https://raw.githubusercontent.com/google/fonts/${revision}/ofl/varela/${lib.escapeURL filename}";
      inherit hash;
    }
  ) files;

  passthru.fontSource = {
    primary = "Varela-Regular.ttf";
    google = "ofl/varela/Varela-Regular.ttf";
  };

  meta = {
    description = "Sans-serif font for headings and small text";
    homepage = "https://fonts.google.com/specimen/Varela";
    license = lib.licenses.ofl;
  };
}
