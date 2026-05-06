cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.129"
  sha256 arm:          "fad2ac75c38ced2c57d046e64927c9ee4846f5ac75ea3bf8f0525ec66438c109",
         x86_64:       "6776c81f4d0629e9ad2166a8bd24967b72ab157b4aa71393d73aa7ca32ed05da",
         arm64_linux:  "be1e037e762e49b28f96f201bbd0fb82153725e16122f6e33623c85fc8f1abc8",
         x86_64_linux: "4af400fa74c8891d69b0cd9e3704ef49133df7a19d5c66456fa0f5e84276e160"

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
