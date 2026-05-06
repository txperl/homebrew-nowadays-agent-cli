cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.132"
  sha256 arm:          "2ce6b9007f38f5caf0d116ae35d59f1a6d40e902ae7f9f19aca6ec483697b764",
         x86_64:       "1953f50853eda4c374dfd558f1cf62a13a99c814aae73b42a07d3d9a49fe727b",
         arm64_linux:  "27266669eda5ae6115837e06230973f565f99b0f25c09ad86aeed404c3f7f947",
         x86_64_linux: "623086f65cfd9c3aff0c8a5125087f8aea3100aa92bf3f0533b2bea5e5d69e8d"

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
