cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.131"
  sha256 arm:          "cc6066b0db7bb423c75316366542f771a41923999a76a5771afad87dd65dceae",
         x86_64:       "a1bd2c782c3f961987d7d6456f75b3fa538cc425f1573908850afedcb038ca5f",
         arm64_linux:  "0919cdf512ca673b38230882b458801b78e9248eb472383631cfc12d8d0d55cf",
         x86_64_linux: "9af15b9302ffde3fa83e3ea4a41cdd00158301cd8badc755567a8e9149f1c36c"

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
