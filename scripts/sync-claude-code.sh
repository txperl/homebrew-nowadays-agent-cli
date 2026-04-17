#!/usr/bin/env bash
# Sync Claude Code casks in this tap.
#   1) Derive the GCS bucket URL from the official installer at https://claude.ai/install.sh
#   2) Mirror Homebrew/homebrew-cask's Casks/c/claude-code.rb byte-for-byte
#   3) Bump Casks/claude-code-latest.rb and Casks/claude-code-stable.rb to the
#      current version + sha256 published on their respective channels.
set -euo pipefail

cd "$(dirname "$0")/.."

# ---- 1. Derive GCS bucket URL from the official installer ------------------
INSTALL_SH_URL="https://claude.ai/install.sh"
INSTALL_SH="$(curl -fsSL "$INSTALL_SH_URL")"

GCS="$(printf '%s\n' "$INSTALL_SH" \
       | sed -nE 's/^[[:space:]]*GCS_BUCKET="([^"]+)".*/\1/p' \
       | head -1)"
if [[ -z "$GCS" ]]; then
  echo "failed to derive GCS_BUCKET from $INSTALL_SH_URL" >&2
  exit 1
fi
GCS="${GCS%/}"
GCS_VERIFIED="${GCS#https://}/"
echo "Using GCS bucket: $GCS"

# ---- 2. Mirror upstream claude-code.rb ------------------------------------
UPSTREAM_CASK_URL="https://raw.githubusercontent.com/Homebrew/homebrew-cask/main/Casks/c/claude-code.rb"
mkdir -p Casks
curl -fsSL "$UPSTREAM_CASK_URL" -o Casks/claude-code.rb
echo "Mirrored upstream cask -> Casks/claude-code.rb"

# ---- 3. Bump latest/stable channel casks ----------------------------------
bump_channel() {
  local channel="$1"   # latest | stable
  local file="$2"      # Casks/claude-code-latest.rb | Casks/claude-code-stable.rb

  local new_version current
  new_version="$(curl -fsSL "$GCS/$channel")"
  current="$(sed -nE 's/^[[:space:]]*version "([^"]+)".*/\1/p' "$file" | head -1)"

  local manifest s_arm s_x64 s_arm_linux s_x64_linux
  manifest="$(curl -fsSL "$GCS/$new_version/manifest.json")"
  s_arm=$(jq -er '.platforms["darwin-arm64"].checksum' <<<"$manifest")
  s_x64=$(jq -er '.platforms["darwin-x64"].checksum'   <<<"$manifest")
  s_arm_linux=$(jq -er '.platforms["linux-arm64"].checksum' <<<"$manifest")
  s_x64_linux=$(jq -er '.platforms["linux-x64"].checksum'   <<<"$manifest")

  echo "[$channel] $current -> $new_version"
  GCS="$GCS" GCS_VERIFIED="$GCS_VERIFIED" \
  FILE="$file" VER="$new_version" \
  S_ARM="$s_arm" S_X64="$s_x64" \
  S_ARM_LINUX="$s_arm_linux" S_X64_LINUX="$s_x64_linux" \
  python3 <<'PY'
import os, re, pathlib

path = pathlib.Path(os.environ["FILE"])
ver  = os.environ["VER"]
gcs  = os.environ["GCS"].rstrip("/")
gcsv = os.environ["GCS_VERIFIED"]
s = path.read_text()

s = re.sub(
    r'(^\s*version\s+")[^"]+(")',
    lambda m: m.group(1) + ver + m.group(2),
    s, count=1, flags=re.M,
)

def sub_key(src, key, sha):
    pat = re.compile(r'(\b' + re.escape(key) + r':\s*")[0-9a-f]{64}(")')
    new, n = pat.subn(lambda m: m.group(1) + sha + m.group(2), src, count=1)
    if n != 1:
        raise SystemExit(f"failed to replace sha256 for {key} in {path}")
    return new

for k, v in [
    ("arm",          os.environ["S_ARM"]),
    ("x86_64",       os.environ["S_X64"]),
    ("arm64_linux",  os.environ["S_ARM_LINUX"]),
    ("x86_64_linux", os.environ["S_X64_LINUX"]),
]:
    s = sub_key(s, k, v)

pat_url = re.compile(
    r'https://storage\.googleapis\.com/[^/"\s]*claude-code-dist[^/"\s]*/claude-code-releases'
)
s = pat_url.sub(gcs, s)

pat_verified = re.compile(
    r'(?<!/)storage\.googleapis\.com/[^/"\s]*claude-code-dist[^/"\s]*/claude-code-releases/'
)
s = pat_verified.sub(gcsv, s)

path.write_text(s)
PY
}

bump_channel latest Casks/claude-code-latest.rb
bump_channel stable Casks/claude-code-stable.rb

echo "done."
