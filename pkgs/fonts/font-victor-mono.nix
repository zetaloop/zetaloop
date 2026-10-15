{
  lib,
  fetchurl,
  mkFont,
  nix-update-script,
}:

let
  version = "1.5.6";
in
mkFont {
  pname = "font-victor-mono";
  inherit version;
  src = fetchurl {
    url = "https://raw.githubusercontent.com/rubjo/victor-mono/v${version}/public/VictorMonoAll.zip";
    hash = "sha256-6rN3rTvMeiAml8Ak67jIco+ZeJxPCT01jz0gIFLMlJY=";
  };

  fontDirectories = [
    "TTF"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "font-victor-mono";
    extraArgs = [
      "--flake"
      "--url"
      "https://github.com/rubjo/victor-mono"
    ];
  };

  meta = {
    description = "Monospaced font with cursive italics and programming ligatures";
    homepage = "https://github.com/rubjo/victor-mono";
    license = lib.licenses.ofl;
  };
}
