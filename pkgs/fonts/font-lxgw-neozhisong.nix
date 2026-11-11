{
  lib,
  fetchurl,
  mkFont,
  python3,
}:

let
  version = "1.071";
in
mkFont {
  pname = "font-lxgw-neozhisong";
  inherit version;
  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v${version}/LXGWNeoZhiSong.ttf";
    hash = "sha256-/VhW+eQ1E6se1uUKvQV7N7UPFfquH/KSwCgEnxaMtE8=";
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
