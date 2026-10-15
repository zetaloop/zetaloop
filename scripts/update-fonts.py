# /// script
# dependencies = [
#     "fonttools",
# ]
# ///

import json
import re
from pathlib import Path, PurePosixPath
from urllib.parse import quote, unquote, urldefrag, urlsplit

from font_resources import download, google_fonts, read_cache, write_cache

ROOT = Path(__file__).parent.parent
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


cache = read_cache()
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
    write_cache(cache)

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
