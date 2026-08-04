# /// script
# dependencies = [
#     "fonttools",
# ]
# ///

import sys
from pathlib import Path

from fontTools.ttLib import TTFont

FAMILY_NAME_IDS = {1, 16, 21}
FULL_NAME_IDS = {3, 4, 6, 18}
SUFFIX = "O"


def save_name(record, text: str) -> None:
    record.string = text.encode(record.getEncoding())


def suffixed(text: str) -> str:
    return text if text.endswith(SUFFIX) else text + SUFFIX


for source_arg in sys.argv[1:]:
    source = Path(source_arg)
    destination = source.with_name(f"{source.stem}{SUFFIX}{source.suffix}")

    font = TTFont(source)
    names = font["name"].names
    families: dict[tuple[int, int, int], str] = {}
    fallback_family: str | None = None

    for record in names:
        if record.nameID not in {1, 16}:
            continue
        try:
            text = record.toUnicode()
        except UnicodeError:
            continue
        key = (record.platformID, record.platEncID, record.langID)
        if record.nameID == 16 or key not in families:
            families[key] = text
        if fallback_family is None or record.nameID == 16:
            fallback_family = text

    for record in names:
        try:
            text = record.toUnicode()
        except UnicodeError:
            continue

        if record.nameID in FAMILY_NAME_IDS:
            replacement = suffixed(text)
        elif record.nameID in FULL_NAME_IDS:
            key = (record.platformID, record.platEncID, record.langID)
            family = families.get(key, fallback_family)
            if not family:
                continue
            if record.nameID == 6:
                family_name, separator, style = text.partition("-")
                replacement = f"{suffixed(family_name)}{separator}{style}"
            else:
                replacement = text.replace(family, suffixed(family), 1)
        else:
            continue

        if replacement != text:
            try:
                save_name(record, replacement)
            except UnicodeEncodeError:
                continue

    font.save(destination)
    font.close()

    font = TTFont(source)
    font["OS/2"].fsSelection |= 1 << 7
    font.save(source)
    font.close()
