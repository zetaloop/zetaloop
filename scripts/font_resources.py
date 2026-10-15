import hashlib
import json
import re
import shutil
from dataclasses import asdict, dataclass
from os import environ
from pathlib import Path, PurePosixPath
from tempfile import TemporaryFile, gettempdir
from urllib.error import HTTPError
from urllib.parse import unquote, urlencode, urlsplit
from urllib.request import Request, urlopen
from zipfile import ZipFile, is_zipfile

from fontTools.ttLib import TTFont

CACHE = Path(environ.get("RUNNER_TEMP", gettempdir())) / "zetaloop-fonts.json"
USER_AGENT = "zetaloop-fonts (+https://github.com/zetaloop/zetaloop)"


@dataclass
class Resource:
    sha256: str
    fonts: dict[str, str]
    etag: str | None
    modified: str | None


def read_cache() -> dict[str, Resource]:
    return (
        {
            url: Resource(**resource)
            for url, resource in json.loads(CACHE.read_text(encoding="utf-8")).items()
        }
        if CACHE.exists()
        else {}
    )


def write_cache(cache: dict[str, Resource]) -> None:
    CACHE.write_text(
        json.dumps({url: asdict(resource) for url, resource in cache.items()}, indent=2)
        + "\n",
        encoding="utf-8",
    )


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
