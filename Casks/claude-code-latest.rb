cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.118"
  sha256 arm:          "54e5d3f65109b89c6046f47440944d52906c662d1e51748f620a430d26ad3665",
         x86_64:       "2cd554070f0588de05e9efd88c1f073770cb620ed3e5f45ba7df833fc3414c1b",
         arm64_linux:  "b77b22fe93c15409f3c64be67950fe11e5fc17d1cd327891596cb87dd9be0492",
         x86_64_linux: "ba363b2410a47120d2d4b8ece2e11fe0bbc5d59adb1329e8fb87ea0f370f4e46"

  url "https://downloads.claude.ai/claude-code-releases/#{version}/#{os}-#{arch}/claude",
      verified: "downloads.claude.ai/claude-code-releases/"
  name "Claude Code"
  desc "Terminal-based AI coding assistant (tracks Anthropic latest channel)"
  homepage "https://www.anthropic.com/claude-code"

  livecheck do
    url "https://downloads.claude.ai/claude-code-releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  conflicts_with cask: [
    "claude-code",
    "txperl/nowadays-agent-cli/claude-code",
    "txperl/nowadays-agent-cli/claude-code-stable",
  ]

  binary "claude"

  zap trash: [
        "~/.cache/claude",
        "~/.claude.json*",
        "~/.config/claude",
        "~/.local/bin/claude",
        "~/.local/share/claude",
        "~/.local/state/claude",
        "~/Library/Caches/claude-cli-nodejs",
      ],
      rmdir: "~/.claude"
end
