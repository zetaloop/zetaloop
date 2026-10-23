{
  lib,
  fetchurl,
  mkFont,
  python3,
}:

let
  version = "1.068";
in
mkFont {
  pname = "font-lxgw-neozhisong";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v${version}/LXGWNeoZhiSong.ttf";
    hash = "sha256-rkgNWSlLajGBc+NYGljRo4XPOtRGemWQsFs3R+opKjo=";
  };

  postPatch = ''
    ${
      python3.withPackages (packages: [ packages.fonttools ])
    }/bin/python ${../../scripts/transform-neozhisong.py} LXGWNeoZhiSong.ttf
  '';

  meta = {
    description = "LXGW Neo ZhiSong Chinese serif font with local metrics variant";
    homepage = "https://github.com/lxgw/LxgwNeoZhiSong";
    license = lib.licenses.ipa;
  };
}
