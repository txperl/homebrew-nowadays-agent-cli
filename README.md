# Nowadays Agent CLI Homebrew Tap

A Homebrew tap for agent CLIs, kept as close to upstream "nowadays" releases as possible via hourly automated syncing from vendor **official** sources.

Currently tracked agents:

- [Claude Code](#claude-code) — by Anthropic

More agent CLIs may be added over time.

## Why this tap exists

Official cask repos are maintained through community PRs and typically lag the actual published release by several point versions.

This tap skips the PR step by having GitHub Actions pull version pointers and per-platform checksums directly from vendor official distribution sources every hour, so `brew upgrade` tracks upstream within minutes instead of days.

## Quick Start

```bash
brew tap txperl/nowadays-agent-cli

# Pick one:
brew install --cask txperl/nowadays-agent-cli/claude-code          # upstream mirror
brew install --cask txperl/nowadays-agent-cli/claude-code-stable   # stable channel
brew install --cask txperl/nowadays-agent-cli/claude-code-latest   # latest channel, recommended
```

> The three `claude-code*` casks share the same `claude` binary and are **mutually exclusive** — installing a second one will fail with a Homebrew conflict error. To switch channels, `brew uninstall --cask` the current one first.

## Trucked

### Claude Code

| Cask                 | Channel                            | Notes                                                                                                                                                 |
| -------------------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `claude-code`        | Mirror of `Homebrew/homebrew-cask` | Byte-for-byte copy of the upstream cask file. (e.g. v2.1.92)                                                                                          |
| `claude-code-stable` | Anthropic GCS `/stable`            | Tracks the channel Anthropic has promoted to stable. (e.g. v2.1.97)                                                                                   |
| `claude-code-latest` | Anthropic GCS `/latest`            | Matches the npm `@anthropic-ai/claude-code` latest tag — the channel Anthropic's official `claude.ai/install.sh` installs by default. (e.g. v2.1.112) |

#### Sources of truth

Resolved at sync time from first-party URLs; nothing is hard-coded:

- GCS bucket — parsed from <https://claude.ai/install.sh>.
- `claude-code` mirror — fetched from [`Homebrew/homebrew-cask`](https://raw.githubusercontent.com/Homebrew/homebrew-cask/main/Casks/c/claude-code.rb).
- Per-version checksums — read from `<GCS>/<version>/manifest.json`.

See [`scripts/sync-claude-code.sh`](scripts/sync-claude-code.sh) and the [sync workflow](.github/workflows/sync-claude-code.yml).

#### Disable Claude Code's built-in auto-updater

Claude Code ships its own updater that may write `~/.local/bin/claude`, shadowing Homebrew's binary via `PATH`. To let `brew` own the binary:

```bash
claude config set -g autoUpdates false
brew update && brew upgrade --cask txperl/nowadays-agent-cli/claude-code-latest
```

This applies regardless of which tap you installed from.

## Sync cadence

Each agent has its own workflow running hourly (and on demand via **Actions → Run workflow**). Runs rewrite cask files from upstream and commit only when the tree changes.

## License

- [MIT](LICENSE)
