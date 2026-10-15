{
  lib,
  stdenvNoCC,
  _7zz,
  python3,
  nix,
  nix-update,
  nix-update-script,
  writeShellApplication,
}:

{
  fontDirectories ? [ "." ],
  ...
}@args:

stdenvNoCC.mkDerivation (
  {
    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;

    unpackCmd = ''
      case "''${curSrc,,}" in
        *.ttf|*.otf|*.ttc)
          cp "$curSrc" "$(stripHash "$curSrc")"
          ;;
        *.zip|*.7z)
          7zz x "$curSrc"
          ;;
        *)
          return 1
          ;;
      esac
    '';

    installPhase = ''
      runHook preInstall
      python3 ${../scripts/font_files.py} "$out" ${lib.escapeShellArgs fontDirectories}
      runHook postInstall
    '';
  }
  // builtins.removeAttrs args [ "fontDirectories" ]
  // {
    nativeBuildInputs = [
      _7zz
      python3
    ]
    ++ args.nativeBuildInputs or [ ];

    passthru = {
      updateScript =
        if args ? passthru.fontSource then
          lib.getExe (writeShellApplication {
            name = "update-${args.pname}";
            runtimeInputs = [
              (python3.withPackages (packages: [ packages.fonttools ]))
              nix
              nix-update
            ];
            text = ''
              python3 scripts/update-nix-fonts.py "$UPDATE_NIX_ATTR_PATH"
            '';
          })
        else
          nix-update-script {
            attrPath = args.pname;
            extraArgs = [ "--flake" ];
          };
    }
    // args.passthru or { };

    meta = {
      platforms = lib.platforms.all;
    }
    // args.meta or { };
  }
)
