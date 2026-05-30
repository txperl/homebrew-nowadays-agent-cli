cask "claude-code-stable" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.149"
  sha256 arm:          "659d1a65cfd439bb43708fd1cfbe8346b59370a27f7f60f789e05f4604dee9a5",
         x86_64:       "666a20a19d0119ced88dd386c3503700ee14f508c7ce3b0047277256a420226d",
         arm64_linux:  "ab11cb6a2c43ef2dd1e68244b2dd470af07de163419a8b073a9b0e157ef64fc3",
         x86_64_linux: "2959c02a605a616fb39cfa23e2f76356b254699dfdd5e5e838fcfb0414e48984"

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
