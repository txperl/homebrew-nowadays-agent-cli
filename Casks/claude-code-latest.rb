cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.147"
  sha256 arm:          "94a81554195edc33c2587f106bfc2e301f450f52a05cbfaed8b20f6f0882697c",
         x86_64:       "91f5a6364d8899860b20c348142fa66e18ee380e6d379b35e3d26b643603c612",
         arm64_linux:  "c7b5b050f9a4cebdc1b369935d3f64078b587b869ae8789c06c437c559d6bb2b",
         x86_64_linux: "d3e134bf504d6ff7db68d0a6f2206c9a15a6d2f94053845116f3303b0a0d79d4"

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
