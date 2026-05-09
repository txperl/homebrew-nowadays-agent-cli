cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.137"
  sha256 arm:          "6d91ce741b8aa129fd43c2f844b39dcc1fec8cfd77e8e5a1ed0f0e7ba54cfea9",
         x86_64:       "bc71e2701a196c1eee65d0cda675f40118aaf11ce469831bb45092fc342527ff",
         arm64_linux:  "8198e7c845a4f3806504b7350424158970c24c56724de400675d6597507d6183",
         x86_64_linux: "ae29f87fdee2d42b5e9ff05c84256bf50a0e7edaa2d58975f9b4b2bd2c29897c"

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
