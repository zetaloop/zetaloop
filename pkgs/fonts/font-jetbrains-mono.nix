{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "2.304";
in
mkFont {
  pname = "font-jetbrains-mono";
  inherit version;
  src = fetchurl {
    url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";
    hash = "sha256-b2N2xu0pYOqKljzXOH7J124/YpElvDPR/c1+twEve78=";
  };

  fontDirectories = [
    "fonts/ttf"
  ];

  meta = {
    description = "Monospaced font for developers with optional ligatures";
    homepage = "https://www.jetbrains.com/lp/mono/";
    license = lib.licenses.ofl;
  };
}
