import json
import re
import sys
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).parent.parent
MANIFEST = ROOT / "bucket" / "vscode.json"
OUTPUT = ROOT / "scripts" / "vscode-registry.json"
USER_AGENT = "zetaloop-vscode-manifest/1 (+https://github.com/zetaloop/zetaloop)"
LANGUAGES = (
    "en",
    "de",
    "es",
    "fr",
    "it",
    "ja",
    "ru",
    "ko",
    "zh-cn",
    "zh-tw",
    "pt-br",
    "hu",
    "tr",
)


def download(url: str) -> str:
    with urlopen(Request(url, headers={"User-Agent": USER_AGENT})) as response:
        return response.read().decode()


version = json.loads(MANIFEST.read_text(encoding="utf-8"))["version"]
if "--force" not in sys.argv and OUTPUT.exists():
    current = json.loads(OUTPUT.read_text(encoding="utf-8"))
    if current.get("version") == version:
        raise SystemExit
release = json.loads(
    download(
        f"https://update.code.visualstudio.com/api/versions/{version}/win32-x64-archive/stable"
    )
)
commit = release["version"]
base = f"https://raw.githubusercontent.com/microsoft/vscode/{commit}/build/win32"
installer = download(f"{base}/code.iss")

labels = dict(
    re.findall(
        r'Subkey: "Software\\Classes\\\{#RegValueName\}(\.[^"]+)"; ValueType: string; ValueName: ""; ValueData: "\{cm:SourceFile,([^}]+)\}";[^\n]*Tasks: associatewithfiles',
        installer,
    )
)
icons = dict(
    re.findall(
        r'Subkey: "Software\\Classes\\\{#RegValueName\}(\.[^"]+)\\DefaultIcon";[^\n]*win32\\([^"}]+)"; Tasks: associatewithfiles',
        installer,
    )
)
if labels.keys() != icons.keys() or not labels:
    raise RuntimeError("Could not parse VS Code file associations")

localizations = {}
for language in LANGUAGES:
    messages = download(f"{base}/i18n/messages.{language}.isl")
    source_file = re.search(r"^SourceFile=(.+)$", messages, re.MULTILINE)
    context_menu = re.search(r"^OpenWithCodeContextMenu=(.+)$", messages, re.MULTILINE)
    if not source_file or not context_menu:
        raise RuntimeError(f"Could not parse {language} installer messages")
    localizations[language] = {
        "sourceFile": source_file.group(1).replace("%1", "{0}"),
        "contextMenu": context_menu.group(1).replace("%1", "Code"),
    }

data = {
    "version": version,
    "commit": commit,
    "source": f"https://github.com/microsoft/vscode/blob/{commit}/build/win32/code.iss",
    "localizations": localizations,
    "associations": [
        [extension, labels[extension], icons[extension]] for extension in labels
    ],
}
OUTPUT.write_text(
    json.dumps(data, ensure_ascii=False, indent=4) + "\n", encoding="utf-8"
)
