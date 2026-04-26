#!/usr/bin/env python3

import argparse
import os
import random
import subprocess
import sys
import time
from pathlib import Path
from typing import List, Optional

HOME = Path.home()
CONFIG_DIR = HOME / ".config"
HYPR_DIR = CONFIG_DIR / "hypr"
SCRIPTS_DIR = HYPR_DIR / "scripts"
RESTART_DIR = SCRIPTS_DIR / "restart"
WALLPAPER_DIR = HOME / "Pictures" / "Wallpapers"
STATE_DIR = Path(os.environ.get("XDG_CACHE_HOME", HOME / ".cache")) / "hyprland-wallpaper"
STATE_FILE = STATE_DIR / "last_wallpaper"
SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}
DEFAULT_INTERVAL = 3600


def run_command(
    cmd: List[str],
    check: bool = True,
    capture_output: bool = False,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        capture_output=capture_output,
    )


def get_images() -> List[Path]:
    if not WALLPAPER_DIR.is_dir():
        raise FileNotFoundError(f"Wallpaper directory not found: {WALLPAPER_DIR}")

    images = sorted(
        path for path in WALLPAPER_DIR.iterdir()
        if path.is_file() and path.suffix.lower() in SUPPORTED_EXTENSIONS
    )
    if not images:
        raise FileNotFoundError(f"No wallpapers found in: {WALLPAPER_DIR}")
    return images


def load_last_wallpaper() -> Optional[str]:
    try:
        return STATE_FILE.read_text(encoding="utf-8").strip() or None
    except FileNotFoundError:
        return None


def save_last_wallpaper(image: Path) -> None:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    STATE_FILE.write_text(str(image), encoding="utf-8")


def ensure_awww_daemon() -> None:
    status = run_command(["awww", "query"], check=False)
    if status.returncode == 0:
        return

    subprocess.Popen(
        ["awww-daemon"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    for _ in range(20):
        time.sleep(0.25)
        status = run_command(["awww", "query"], check=False)
        if status.returncode == 0:
            return

    raise RuntimeError("awww-daemon did not become ready in time.")


def choose_image(images: List[Path], last_wallpaper: Optional[str]) -> Path:
    if len(images) == 1:
        return images[0]

    candidates = [image for image in images if str(image) != last_wallpaper]
    if not candidates:
        candidates = images
    return random.choice(candidates)


def get_restart_scripts() -> List[Path]:
    if not RESTART_DIR.is_dir():
        return []

    return sorted(
        path for path in RESTART_DIR.iterdir()
        if path.is_file() and path.suffix == ".sh" and os.access(path, os.X_OK) and path.name != "selector.sh"
    )


def is_panel_active(panel_name: str) -> bool:
    result = run_command(["pgrep", "-x", panel_name], check=False, capture_output=True)
    return result.returncode == 0


def get_active_panel_scripts() -> List[Path]:
    active_scripts: List[Path] = []
    for script in get_restart_scripts():
        if is_panel_active(script.stem):
            active_scripts.append(script)
    return active_scripts


def restart_active_panels() -> None:
    active_scripts = get_active_panel_scripts()
    if not active_scripts:
        print("Skip panel restart: no active panel detected.", file=sys.stderr)
        return

    if len(active_scripts) > 1:
        names = ", ".join(script.stem for script in active_scripts)
        print(f"Multiple active panels detected, restarting all: {names}", file=sys.stderr)

    for script in active_scripts:
        result = run_command([str(script)], check=False, capture_output=True)
        if result.returncode != 0:
            stderr = (result.stderr or "").strip()
            print(
                f"Warning: failed to run {script.name}: {stderr or 'unknown error'}",
                file=sys.stderr,
            )


def refresh_wal(image: Path) -> None:
    run_command(["wal", "-i", str(image)])
    restart_active_panels()


def apply_wallpaper(image: Path, with_wal: bool) -> None:
    ensure_awww_daemon()
    run_command([
        "awww", "img", str(image),
        "--transition-type", "random",
        "--transition-duration", "1",
    ])
    save_last_wallpaper(image)

    if with_wal:
        refresh_wal(image)

    print(f"Wallpaper updated: {image}")


def set_next_wallpaper(with_wal: bool) -> None:
    images = get_images()
    image = choose_image(images, load_last_wallpaper())
    apply_wallpaper(image, with_wal=with_wal)


def run_daemon(interval: int, with_wal: bool) -> None:
    while True:
        set_next_wallpaper(with_wal=with_wal)
        time.sleep(interval)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Wallpaper manager for Hyprland + awww.",
        epilog=(
            "Examples:\n"
            "  wallpaper.py once\n"
            "  wallpaper.py once --with-wal\n"
            "  wallpaper.py daemon --interval 1800 --with-wal"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    once_parser = subparsers.add_parser("once", help="Change wallpaper once.")
    once_parser.add_argument(
        "--with-wal",
        action="store_true",
        help="Regenerate pywal colors and refresh dependent apps.",
    )

    daemon_parser = subparsers.add_parser("daemon", help="Rotate wallpaper on an interval.")
    daemon_parser.add_argument(
        "--interval",
        type=int,
        default=DEFAULT_INTERVAL,
        help=f"Seconds between wallpaper changes. Default: {DEFAULT_INTERVAL}.",
    )
    daemon_parser.add_argument(
        "--with-wal",
        action="store_true",
        help="Regenerate pywal colors and refresh dependent apps on each change.",
    )

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "once":
        set_next_wallpaper(with_wal=args.with_wal)
        return 0

    if args.interval <= 0:
        parser.error("--interval must be greater than 0.")

    run_daemon(interval=args.interval, with_wal=args.with_wal)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(130)
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        raise SystemExit(1)
