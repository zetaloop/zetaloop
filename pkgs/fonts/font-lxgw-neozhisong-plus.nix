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
  pname = "font-lxgw-neozhisong-plus";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v${version}/LXGWNeoZhiSongPlus.ttf";
    hash = "sha256-CKd65yM9hLEym3rEMJerfDzOS/yOabrXheq0Lvg0kRk=";
  };

  postPatch = ''
    ${
      python3.withPackages (packages: [ packages.fonttools ])
    }/bin/python ${../../scripts/transform-neozhisong.py} LXGWNeoZhiSongPlus.ttf
  '';

  meta = {
    description = "Extended LXGW Neo ZhiSong Chinese serif font with local metrics variant";
    homepage = "https://github.com/lxgw/LxgwNeoZhiSong";
    license = lib.licenses.ipa;
  };
}
