# /// script
# dependencies = [
#     "fonttools",
# ]
# ///

import hashlib
import json
import re
import shutil
from dataclasses import asdict, dataclass
from os import environ
from pathlib import Path, PurePosixPath
from tempfile import TemporaryFile, gettempdir
from urllib.error import HTTPError
from urllib.parse import urldefrag
from urllib.request import Request, urlopen
from zipfile import ZipFile

from fontTools.ttLib import TTFont

ROOT = Path(__file__).parent.parent
CACHE = Path(environ.get("RUNNER_TEMP", gettempdir())) / "zetaloop-fonts.json"
USER_AGENT = "zetaloop-fonts (+https://github.com/zetaloop/zetaloop)"
FONTS = {
    "font-alibaba-puhuiti": "AlibabaPuHuiTi-3-55-Regular.ttf",
    "font-harmonyos-sans": "HarmonyOS_Sans.ttf",
    "font-misans": "MiSansVF.ttf",
    "font-misans-tc": "MisansTC VF.ttf",
    "font-misans-l3": "MiSans L3.ttf",
}


@dataclass
class Resource:
    sha256: str
    fonts: dict[str, str]
    etag: str | None
    modified: str | None


def download(url: str, headers: dict[str, str], cached: Resource | None) -> Resource:
    headers = {"User-Agent": USER_AGENT, **headers}
    if cached:
        if cached.etag:
            headers["If-None-Match"] = cached.etag
        if cached.modified:
            headers["If-Modified-Since"] = cached.modified
    try:
        response = urlopen(Request(url, headers=headers))
    except HTTPError as error:
        if error.code == 304 and cached:
            error.close()
            print("HTTP 304")
            return cached
        raise

    with response, TemporaryFile() as archive:
        shutil.copyfileobj(response, archive)
        archive.seek(0)
        digest = hashlib.file_digest(archive, "sha256").hexdigest()
        fonts = {}
        with ZipFile(archive, metadata_encoding="utf-8") as package:
            names = {
                name
                for name in package.namelist()
                if PurePosixPath(name).suffix.lower() in {".ttf", ".otf"}
                and not PurePosixPath(name).name.startswith("._")
            }
            folded = {name.casefold() for name in names}
            for name in sorted(names):
                path = PurePosixPath(name)
                if (
                    path.suffix.lower() == ".otf"
                    and str(path.with_suffix(".ttf")).casefold() in folded
                ):
                    continue
                with package.open(name) as stream, TTFont(stream, lazy=True) as font:
                    version = re.search(
                        r"\d+(?:\.\d+)+", font["name"].getDebugName(5) or ""
                    )
                    if not version:
                        raise ValueError(f"Missing font version in {name}")
                    fonts[name] = version.group()
        return Resource(
            digest,
            fonts,
            response.headers.get("ETag"),
            response.headers.get("Last-Modified"),
        )


cache = (
    {
        url: Resource(**resource)
        for url, resource in json.loads(CACHE.read_text(encoding="utf-8")).items()
    }
    if CACHE.exists()
    else {}
)
for name, primary in FONTS.items():
    manifest_path = ROOT / "bucket" / f"{name}.json"
    cask_path = ROOT / "Casks" / f"{name}.rb"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    cask = cask_path.read_text(encoding="utf-8")
    fields = dict(re.findall(r'^  (\w+) "([^"]+)"', cask, re.MULTILINE))
    referer = re.search(r'^\s+referer: "([^"]+)"', cask, re.MULTILINE)
    headers = {"Referer": referer.group(1)} if referer else {}
    url = fields["url"]
    print(f"{name}: checking {url}", flush=True)
    resource = download(url, headers, cache.get(url))
    cache[url] = resource
    CACHE.write_text(
        json.dumps({url: asdict(resource) for url, resource in cache.items()}, indent=2)
        + "\n",
        encoding="utf-8",
    )

    directory = PurePosixPath(manifest.get("extract_dir", "").replace("\\", "/"))
    fonts = {
        path: version
        for path, version in resource.fonts.items()
        if PurePosixPath(path).is_relative_to(directory)
    }
    versions = [
        version
        for path, version in fonts.items()
        if PurePosixPath(path).name == primary
    ]
    if len(versions) != 1:
        raise ValueError(f"Expected one {primary} in {url}")
    version = versions[0]
    manifest["version"] = version
    if "hash" in manifest:
        _, fragment = urldefrag(manifest["url"])
        manifest["url"] = f"{url}#{fragment}" if fragment else url
        manifest["hash"] = resource.sha256
    else:
        manifest["pre_install"] = [
            line.replace(fields["sha256"], resource.sha256)
            for line in manifest["pre_install"]
        ]
    cask = re.sub(
        r'^  version "[^"]+"',
        f'  version "{version}"',
        cask,
        count=1,
        flags=re.MULTILINE,
    )
    cask = re.sub(
        r'^  sha256 "[^"]+"',
        f'  sha256 "{resource.sha256}"',
        cask,
        count=1,
        flags=re.MULTILINE,
    )
    cask = re.sub(
        r"^  font .*(?:\n  font .*)*",
        lambda _, fonts=fonts: "\n".join(
            f"  font {json.dumps(path, ensure_ascii=False)}" for path in fonts
        ),
        cask,
        count=1,
        flags=re.MULTILINE,
    )
    manifest_path.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=4) + "\n", encoding="utf-8"
    )
    cask_path.write_text(cask, encoding="utf-8")
    print(f"{name}: {version}")
