cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.123"
  sha256 arm:          "44597dff0f1c11e37c1954d4ac3965909be376e5961b558345723357253bcc90",
         x86_64:       "ddea227d4c2b2602d650d2c5d5c812f7680701a1504bcaff81e42c165c583ef9",
         arm64_linux:  "825c526035d1d75ff0bc1eebf18c887f98d07ea49ea80bd312ff416fe61a39b3",
         x86_64_linux: "5a78139b679a86a88a0ac5476c706a64c3105bf6a6d435ba10f3aa3fb635bdb2"

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
