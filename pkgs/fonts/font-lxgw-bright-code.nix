{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "2.922";
in
mkFont {
  pname = "font-lxgw-bright-code";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwBright-Code/releases/download/${version}/LxgwBrightCode.7z";
    hash = "sha256-v+/F8yEyvyhKA5AR3qvqQLo1Dqqw2GKeGqFgIyiX090=";
  };

  meta = {
    description = "Monospace programming variant of LXGW Bright";
    homepage = "https://github.com/lxgw/LxgwBright-Code";
    license = lib.licenses.ofl;
  };
}
