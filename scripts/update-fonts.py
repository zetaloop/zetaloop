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
from urllib.parse import quote, unquote, urldefrag, urlencode, urlsplit
from urllib.request import Request, urlopen
from zipfile import ZipFile, is_zipfile

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
GOOGLE_FONTS = {
    "font-mulish": "ofl/mulish/Mulish[wght].ttf",
    "font-varela": "ofl/varela/Varela-Regular.ttf",
    "font-varela-round": "ofl/varelaround/VarelaRound-Regular.ttf",
}


@dataclass
class Resource:
    sha256: str
    fonts: dict[str, str]
    etag: str | None
    modified: str | None


def font_version(font: TTFont) -> str:
    version = re.search(r"\d+(?:\.\d+)+", font["name"].getDebugName(5) or "")
    if not version:
        raise ValueError("Missing font version")
    return version.group()


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
        if is_zipfile(archive):
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
                    with (
                        package.open(name) as stream,
                        TTFont(stream, lazy=True) as font,
                    ):
                        fonts[name] = font_version(font)
        else:
            archive.seek(0)
            filename = PurePosixPath(unquote(urlsplit(url).path)).name
            with TTFont(archive, lazy=True) as font:
                fonts[filename] = font_version(font)
        return Resource(
            digest,
            fonts,
            response.headers.get("ETag"),
            response.headers.get("Last-Modified"),
        )


def github(endpoint: str) -> str:
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/vnd.github+json",
    }
    if token := environ.get("GITHUB_TOKEN"):
        headers["Authorization"] = f"Bearer {token}"
    with urlopen(
        Request(
            f"https://api.github.com/repos/google/fonts/{endpoint}", headers=headers
        )
    ) as response:
        return response.read().decode()


def google_fonts(
    source: str, cache: dict[str, Resource]
) -> tuple[str, dict[str, Resource]]:
    query = urlencode({"path": source, "per_page": 1})
    revision = json.loads(github(f"commits?{query}"))[0]["sha"]
    files = json.loads(github(f"contents/{source}?ref={revision}"))
    if isinstance(files, dict):
        files = [files]
    resources = {}
    for file in files:
        if (
            file["type"] != "file"
            or PurePosixPath(file["name"]).suffix.lower() != ".ttf"
        ):
            continue
        key = f"git:{file['sha']}"
        if key not in cache:
            cache[key] = download(file["download_url"], {}, None)
        resources[file["name"]] = cache[key]
    return revision, resources


cache = (
    {
        url: Resource(**resource)
        for url, resource in json.loads(CACHE.read_text(encoding="utf-8")).items()
    }
    if CACHE.exists()
    else {}
)
for name, primary in (FONTS | GOOGLE_FONTS).items():
    manifest_path = ROOT / "bucket" / f"{name}.json"
    cask_path = ROOT / "Casks" / f"{name}.rb"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    cask = cask_path.read_text(encoding="utf-8")
    fields = dict(re.findall(r'^  (\w+) "([^"]+)"', cask, re.MULTILINE))
    stanzas = {}
    print(f"{name}: checking", flush=True)
    if name in GOOGLE_FONTS:
        directory = str(PurePosixPath(primary).parent)
        source = directory if fields["url"].endswith(".git") else primary
        revision, resources = google_fonts(source, cache)
        fonts = {
            filename: next(iter(resource.fonts.values()))
            for filename, resource in resources.items()
        }
        current_urls = manifest["url"]
        current_hashes = manifest["hash"]
        if isinstance(current_urls, str):
            current_urls = [current_urls]
            current_hashes = [current_hashes]
        filenames = [
            PurePosixPath(unquote(urlsplit(url).path)).name for url in current_urls
        ]
        hashes = {filename: resource.sha256 for filename, resource in resources.items()}
        if dict(zip(filenames, current_hashes, strict=True)) == hashes:
            revision = urlsplit(current_urls[0]).path.split("/")[3]
        aliases = {
            filename: urldefrag(url)[1]
            for filename, url in zip(filenames, current_urls, strict=True)
        }
        raw_urls = [
            f"https://raw.githubusercontent.com/google/fonts/{revision}/{directory}/{quote(filename)}"
            for filename in fonts
        ]
        urls = [
            f"{url}#{aliases[filename]}" if aliases.get(filename) else url
            for filename, url in zip(fonts, raw_urls, strict=True)
        ]
        manifest["url"] = urls[0] if len(urls) == 1 else urls
        manifest["hash"] = (
            next(iter(hashes.values())) if len(hashes) == 1 else list(hashes.values())
        )
        if fields["url"].endswith(".git"):
            cask = re.sub(
                r'(?m)^(\s+revision: )"[^"]+"',
                rf'\g<1>"{revision}"',
                cask,
                count=1,
            )
        else:
            stanzas["url"] = raw_urls[0]
            stanzas["sha256"] = next(iter(hashes.values()))
    else:
        referer = re.search(r'^\s+referer: "([^"]+)"', cask, re.MULTILINE)
        headers = {"Referer": referer.group(1)} if referer else {}
        url = fields["url"]
        resource = download(url, headers, cache.get(url))
        cache[url] = resource
        directory = PurePosixPath(manifest.get("extract_dir", "").replace("\\", "/"))
        fonts = {
            path: version
            for path, version in resource.fonts.items()
            if PurePosixPath(path).is_relative_to(directory)
        }
        if "hash" in manifest:
            _, fragment = urldefrag(manifest["url"])
            manifest["url"] = f"{url}#{fragment}" if fragment else url
            manifest["hash"] = resource.sha256
        else:
            manifest["pre_install"] = [
                line.replace(fields["sha256"], resource.sha256)
                for line in manifest["pre_install"]
            ]
        stanzas["sha256"] = resource.sha256
    CACHE.write_text(
        json.dumps({url: asdict(resource) for url, resource in cache.items()}, indent=2)
        + "\n",
        encoding="utf-8",
    )

    versions = [
        version
        for path, version in fonts.items()
        if PurePosixPath(path).name == PurePosixPath(primary).name
    ]
    if len(versions) != 1:
        raise ValueError(f"Expected one {primary} in {name}")
    version = versions[0]
    manifest["version"] = version
    stanzas["version"] = version
    for key, value in stanzas.items():
        cask = re.sub(
            rf'^  {key} "[^"]+"',
            f'  {key} "{value}"',
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
