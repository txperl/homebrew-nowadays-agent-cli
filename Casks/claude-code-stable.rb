cask "claude-code-stable" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.138"
  sha256 arm:          "759d23ce626193c89bc8b35c5c6ca8a9e33b9c2e504ee143e4cd119988774097",
         x86_64:       "d99d3a7afd63841943906b11ed8791b0ee47fe5cf95601a8b805c20900014f54",
         arm64_linux:  "693ecca41a62d58fee660884bd982ca5cdeab5b277925fcdfe880cdf02f98671",
         x86_64_linux: "c3c56ffbc12cf16e40c33687c9fe6361ed250c35a9e1718d0c38d49049f5f8c3"

  url "https://downloads.claude.ai/claude-code-releases/#{version}/#{os}-#{arch}/claude",
      verified: "downloads.claude.ai/claude-code-releases/"
  name "Claude Code"
  desc "Terminal-based AI coding assistant (tracks Anthropic stable channel)"
  homepage "https://www.anthropic.com/claude-code"

  livecheck do
    url "https://downloads.claude.ai/claude-code-releases/stable"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  conflicts_with cask: [
    "claude-code",
    "txperl/nowadays-agent-cli/claude-code",
    "txperl/nowadays-agent-cli/claude-code-latest",
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
