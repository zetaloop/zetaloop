import json
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath
from tempfile import TemporaryDirectory
from urllib.parse import urlsplit

ROOT = Path(__file__).parent.parent
EXTENSIONS = {".otf", ".ttf", ".ttc"}

for package in sys.argv[1:]:
    info = json.loads(
        subprocess.check_output(
            ["brew", "info", "--json=v2", "--cask", package], text=True
        )
    )["casks"][0]
    if PurePosixPath(urlsplit(info["url"]).path).suffix.lower() in EXTENSIONS:
        continue
    name = info["token"]
    version = info["version"]
    manifest = json.loads(
        (ROOT / "bucket" / f"{name}.json").read_text(encoding="utf-8")
    )
    directory = manifest.get("autoupdate", {}).get(
        "extract_dir", manifest.get("extract_dir", "")
    )
    directory = PurePosixPath(directory.replace("$version", version).replace("\\", "/"))
    installer = manifest.get("installer", {})
    directories = [directory]
    if installer.get("file") == "install-fonts.ps1" and len(installer["args"]) > 1:
        directories = [
            directory / path.removeprefix("$dir").lstrip("\\/").replace("\\", "/")
            for path in installer["args"][1:]
        ]

    with TemporaryDirectory() as temporary:
        subprocess.run(
            ["brew", "unpack", "--cask", f"--destdir={temporary}", package], check=True
        )
        root = Path(temporary) / f"{name}-{version}"
        files = {
            path.relative_to(root)
            for path in root.rglob("*")
            if path.is_file()
            and path.suffix.lower() in EXTENSIONS
            and not path.name.startswith("._")
            and any(
                path.relative_to(root).is_relative_to(scope) for scope in directories
            )
        }
        folded = {path.as_posix().casefold() for path in files}
        fonts = sorted(
            path.as_posix()
            for path in files
            if path.suffix.lower() != ".otf"
            or path.with_suffix(".ttf").as_posix().casefold() not in folded
        )
    if not fonts:
        raise ValueError(f"No font files found for {package}")

    cask_path = ROOT / "Casks" / f"{name}.rb"
    cask = cask_path.read_text(encoding="utf-8")
    lines = "\n".join(
        "  font "
        + json.dumps(path, ensure_ascii=False)
        .replace("#{", "\\#{")
        .replace(version, "#{version}")
        for path in fonts
    )
    cask, count = re.subn(
        r"^  font .*(?:\n  font .*)*",
        lambda _, lines=lines: lines,
        cask,
        count=1,
        flags=re.MULTILINE,
    )
    if count != 1:
        raise ValueError(f"Missing font declarations in {cask_path}")
    cask_path.write_text(cask, encoding="utf-8")
