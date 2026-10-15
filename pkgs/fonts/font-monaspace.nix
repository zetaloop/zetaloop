{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "1.400";
in
mkFont {
  pname = "font-monaspace";
  inherit version;
  src = fetchurl {
    url = "https://github.com/githubnext/monaspace/releases/download/v${version}/monaspace-variable-v${version}.zip";
    hash = "sha256-tpp/KjxFXInctswjthuz+4vuy6cozN6+zNgFd+WN4Mg=";
  };

  meta = {
    description = "Expressive variable type superfamily for code";
    homepage = "https://monaspace.githubnext.com/";
    license = lib.licenses.ofl;
  };
}
