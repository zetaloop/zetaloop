import shutil
import sys
from pathlib import Path, PurePosixPath

EXTENSIONS = {".otf", ".ttf", ".ttc"}


def font_files(root: Path, directories: list[PurePosixPath]) -> list[Path]:
    files = {
        path.relative_to(root)
        for path in root.rglob("*")
        if path.is_file()
        and path.suffix.lower() in EXTENSIONS
        and not path.name.startswith("._")
        and any(path.relative_to(root).is_relative_to(scope) for scope in directories)
    }
    folded = {path.as_posix().casefold() for path in files}
    fonts = sorted(
        (
            path
            for path in files
            if path.suffix.lower() != ".otf"
            or path.with_suffix(".ttf").as_posix().casefold() not in folded
        ),
        key=lambda path: path.as_posix(),
    )
    if not fonts:
        raise ValueError(f"No font files found in {root}")
    return fonts


if __name__ == "__main__":
    output = Path(sys.argv[1])
    for path in font_files(
        Path.cwd(), [PurePosixPath(directory) for directory in sys.argv[2:]]
    ):
        format_directory = "opentype" if path.suffix.lower() == ".otf" else "truetype"
        destination = output / "share" / "fonts" / format_directory / path
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, destination)
