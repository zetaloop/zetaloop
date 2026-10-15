# /// script
# dependencies = [
#     "fonttools",
# ]
# ///

import base64
import json
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath
from urllib.parse import unquote, urlsplit

from font_resources import download, google_fonts, read_cache, write_cache

ROOT = Path(__file__).parent.parent
package = sys.argv[1]
info = json.loads(
    subprocess.check_output(
        [
            "nix",
            "eval",
            "--json",
            f".#{package}",
            "--apply",
            "p: { inherit (p) fontSource; resources = map (s: { url = builtins.head s.urls; hash = s.outputHash; }) (p.srcs or [ p.src ]); }",
        ],
        text=True,
    )
)
source = info["fontSource"]
cache = read_cache()
filename = ROOT / "pkgs" / "fonts" / f"{package}.nix"
replacements = {}
files = None

if "google" in source:
    revision, resources = google_fonts(source["google"], cache)
    fonts = {
        name: next(iter(resource.fonts.values()))
        for name, resource in resources.items()
    }
    files = {
        name: "sha256-" + base64.b64encode(bytes.fromhex(resource.sha256)).decode()
        for name, resource in resources.items()
    }
    current = {
        PurePosixPath(unquote(urlsplit(resource["url"]).path)).name: resource["hash"]
        for resource in info["resources"]
    }
    if current != files:
        old_revision = urlsplit(info["resources"][0]["url"]).path.split("/")[3]
        replacements[old_revision] = revision
else:
    current = info["resources"][0]
    url = current["url"]
    resource = download(url, source.get("headers", {}), cache.get(url))
    cache[url] = resource
    fonts = resource.fonts
    replacements[current["hash"]] = (
        "sha256-" + base64.b64encode(bytes.fromhex(resource.sha256)).decode()
    )

write_cache(cache)
versions = [
    version
    for path, version in fonts.items()
    if PurePosixPath(path).name == source["primary"]
]
if len(versions) != 1:
    raise ValueError(f"Expected one {source['primary']} in {package}")
version = versions[0]
subprocess.run(
    [
        "nix-update",
        package,
        "--flake",
        f"--version={version}",
        "--no-src",
        "--override-filename",
        str(filename),
    ],
    check=True,
)

text = filename.read_text(encoding="utf-8")
for old, new in replacements.items():
    text = text.replace(json.dumps(old), json.dumps(new))
if files is not None:
    entries = "\n".join(
        f"    {json.dumps(name)} = {json.dumps(hash_value)};"
        for name, hash_value in sorted(files.items())
    )
    text, count = re.subn(
        r"^  files = \{\n.*?^  \};",
        lambda _: f"  files = {{\n{entries}\n  }};",
        text,
        count=1,
        flags=re.MULTILINE | re.DOTALL,
    )
    if count != 1:
        raise ValueError(f"Missing font files in {filename}")
filename.write_text(text, encoding="utf-8")
print(f"{package}: {version}")
