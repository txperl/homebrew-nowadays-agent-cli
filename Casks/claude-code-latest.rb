cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.117"
  sha256 arm:          "12cf77a447d129d3fb691023ee3ced3e43efbde72ab910c6162db2c7be5ca374",
         x86_64:       "c6614176252bc789000ad7b8a19b22957a4e9d40878773e98dafde6bbda63e86",
         arm64_linux:  "302c9c189552dc261b1c4511d0d8c9147baeaa4bf7e50785873fa1699ee51f22",
         x86_64_linux: "b7246963d9e32ece439c3e1e7885f53773a4820e90a4d2433ef2a413a055a5fe"

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
