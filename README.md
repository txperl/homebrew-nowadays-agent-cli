# Nowadays Agent CLI Homebrew Tap

A Homebrew tap for agent CLIs, kept as close to upstream "nowadays" releases as possible via hourly automated syncing from **official** vendor sources.

Currently tracked agents:

- [Claude Code](#claude-code) — by Anthropic

More agent CLIs may be added over time.

## Why this tap exists

Official cask repos are maintained through community PRs and typically lag the actual published release by several point versions.

This tap skips the PR step by having GitHub Actions pull version pointers and per-platform checksums directly from official vendor distribution sources every hour, so `brew upgrade` tracks upstream within minutes instead of days.

## Quick Start

```bash
brew tap txperl/nowadays-agent-cli

# Pick one:
brew install --cask txperl/nowadays-agent-cli/claude-code          # upstream mirror
brew install --cask txperl/nowadays-agent-cli/claude-code-stable   # stable channel
brew install --cask txperl/nowadays-agent-cli/claude-code-latest   # latest channel, recommended
```

> The three `claude-code*` casks share the same `claude` binary and are **mutually exclusive** — installing a second one will fail with a Homebrew conflict error. To switch channels, `brew uninstall --cask` the current one first.

## Tracked

### Claude Code

| Cask                 | Channel                            | Notes                                                                   |
| -------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| `claude-code`        | Mirror of `Homebrew/homebrew-cask` | Byte-for-byte copy of the upstream cask file. (e.g. v2.1.92)            |
| `claude-code-stable` | Anthropic `/stable`                | Tracks the channel Anthropic has promoted to stable. (e.g. v2.1.97)     |
| `claude-code-latest` | Anthropic `/latest`                | Matches the npm `@anthropic-ai/claude-code` latest tag. (e.g. v2.1.112) |

The `claude-code-latest` channel is the one Anthropic's official `claude.ai/install.sh` installs by default.

#### Sources of truth

All sync URLs live on Anthropic or Homebrew official domains:

- Download base — [`downloads.claude.ai/claude-code-releases`](https://downloads.claude.ai/claude-code-releases), same endpoint [`claude.ai/install.sh`](https://claude.ai/install.sh) uses.
- Versions & checksums — `<base>/{latest,stable}`, `<base>/<version>/manifest.json`.
- `claude-code` mirror — [upstream Homebrew cask](https://raw.githubusercontent.com/Homebrew/homebrew-cask/main/Casks/c/claude-code.rb).

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
