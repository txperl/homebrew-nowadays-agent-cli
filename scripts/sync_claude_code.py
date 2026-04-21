#!/usr/bin/env python3
"""Sync Claude Code casks in this tap.

1) Mirror Homebrew/homebrew-cask's Casks/c/claude-code.rb byte-for-byte.
2) Render Casks/claude-code-{latest,stable}.rb from the shared template,
   using the version + per-platform sha256 published on each channel.
"""

from __future__ import annotations

import json
import os
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


def mirror_upstream_cask() -> bool:
    dest = CASKS_DIR / "claude-code.rb"
    new_content = fetch_bytes(UPSTREAM_CASK_URL)
    old_content = dest.read_bytes() if dest.exists() else b""
    if new_content == old_content:
        print(f"Mirror unchanged: {dest.relative_to(REPO_ROOT)}")
        return False
    dest.write_bytes(new_content)
    print(f"Mirrored upstream cask -> {dest.relative_to(REPO_ROOT)}")
    return True


def render_channel(channel: str, peer: str) -> tuple[str, str]:
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
    return old, new_version


def build_commit_subject(
    mirror_changed: bool,
    channel_results: dict[str, tuple[str, str]],
) -> str | None:
    changes: list[tuple[str, str | None]] = []
    if mirror_changed:
        changes.append(("mirror", None))
    for channel, (old, new) in channel_results.items():
        if old != new:
            changes.append((channel, new))

    if not changes:
        return None

    if len(changes) == 1:
        name, version = changes[0]
        if version is None:
            return "chore(cask): mirror upstream claude-code"
        return f"chore(cask): bump claude-code-{name} to v{version}"

    def fmt(entry: tuple[str, str | None]) -> str:
        name, version = entry
        return name if version is None else f"{name} v{version}"

    return f"chore(cask): sync claude-code ({', '.join(fmt(c) for c in changes)})"


def main() -> int:
    print(f"Using download base: {GCS}")
    mirror_changed = mirror_upstream_cask()
    channel_results: dict[str, tuple[str, str]] = {
        "latest": render_channel("latest", peer="stable"),
        "stable": render_channel("stable", peer="latest"),
    }

    subject = build_commit_subject(mirror_changed, channel_results)
    if subject:
        print(f"commit subject: {subject}")
        subject_file = os.environ.get("SYNC_COMMIT_SUBJECT_FILE")
        if subject_file:
            Path(subject_file).write_text(subject + "\n")
    else:
        print("no changes")

    print("done.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
