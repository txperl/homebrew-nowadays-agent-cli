#!/usr/bin/env python3
"""Sync Claude Code casks in this tap.

1) Mirror Homebrew/homebrew-cask's Casks/c/claude-code.rb byte-for-byte.
2) Render Casks/claude-code-{latest,stable}.rb from the shared template,
   using the version + per-platform sha256 published on each channel.
"""

from __future__ import annotations

import json
import sys
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CASKS_DIR = REPO_ROOT / "Casks"
TEMPLATE = REPO_ROOT / "scripts" / "templates" / "claude-code-channel.rb.tmpl"

GCS = "https://downloads.claude.ai/claude-code-releases"
UPSTREAM_CASK_URL = (
    "https://raw.githubusercontent.com/Homebrew/homebrew-cask/main/Casks/c/claude-code.rb"
)

PLATFORM_KEYS = {
    "sha_arm": "darwin-arm64",
    "sha_x86_64": "darwin-x64",
    "sha_arm64_linux": "linux-arm64",
    "sha_x86_64_linux": "linux-x64",
}


def fetch_bytes(url: str) -> bytes:
    with urllib.request.urlopen(url) as resp:
        return resp.read()


def fetch_text(url: str) -> str:
    return fetch_bytes(url).decode("utf-8")


def fetch_json(url: str) -> dict:
    return json.loads(fetch_text(url))


def current_version(path: Path) -> str:
    for line in path.read_text().splitlines():
        stripped = line.strip()
        if stripped.startswith('version "'):
            return stripped.split('"', 2)[1]
    return "(none)"


def mirror_upstream_cask() -> None:
    dest = CASKS_DIR / "claude-code.rb"
    dest.write_bytes(fetch_bytes(UPSTREAM_CASK_URL))
    print(f"Mirrored upstream cask -> {dest.relative_to(REPO_ROOT)}")


def render_channel(channel: str, peer: str) -> None:
    dest = CASKS_DIR / f"claude-code-{channel}.rb"
    old = current_version(dest) if dest.exists() else "(none)"

    new_version = fetch_text(f"{GCS}/{channel}").strip()
    manifest = fetch_json(f"{GCS}/{new_version}/manifest.json")
    platforms = manifest.get("platforms") or {}

    values = {"channel": channel, "peer": peer, "version": new_version}
    for placeholder, plat_key in PLATFORM_KEYS.items():
        entry = platforms.get(plat_key)
        if not entry or "checksum" not in entry:
            raise SystemExit(
                f"manifest for {new_version} missing platform {plat_key!r}"
            )
        values[placeholder] = entry["checksum"]

    rendered = TEMPLATE.read_text()
    for key, val in values.items():
        rendered = rendered.replace(f"{{{{{key}}}}}", val)

    dest.write_text(rendered)
    print(f"[{channel}] {old} -> {new_version}")


def main() -> int:
    print(f"Using download base: {GCS}")
    mirror_upstream_cask()
    render_channel("latest", peer="stable")
    render_channel("stable", peer="latest")
    print("done.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
