cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.121"
  sha256 arm:          "3810e55d47ed4d413de6dc037e34d58948f779a4c6bdeeacf1748d850c5daad6",
         x86_64:       "59d817dde54eeef0d752e7bd3869586e6eb5fa2b1d785c06fb9cda8804166037",
         arm64_linux:  "71b78e6364f97a227b17be40dfcc237461f8d2b1d109444d24b42af0fdefac31",
         x86_64_linux: "b4b684bbcb3a88029ec419dbc08824b2f3c69656a0aa2374860f9525fc67c98f"

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
