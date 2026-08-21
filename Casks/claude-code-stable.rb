cask "claude-code-stable" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.231"
  sha256 arm:          "ba790279cab6ef77b713864d4bf5f764fcea87d3a3eb7591a41f741e45212b5c",
         x86_64:       "7c7c6179f55c985409af4c31603d19b9b64af4759d016f86b99bfbdb29042a90",
         arm64_linux:  "4ee7c484b11dece6521aa2173a19ea913428c1c78599186d62559d2d2aef4e32",
         x86_64_linux: "47a01daebf794f6c86c13d1875ad6e5be0627029ad8600731161f24018ecde5b"

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
