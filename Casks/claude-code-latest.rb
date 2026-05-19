cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.145"
  sha256 arm:          "368dcd9709c85534f673071e7cc8eb5422bcff367fb9bdf5ce25d9619aab7ef5",
         x86_64:       "c23dc566214279d0708f4212261f023d8e63d5af5aef91638ebfdc090b3e33de",
         arm64_linux:  "75ad61d690d79440c82b5841444e1b42caae55736af37c97dd0e068ef20ce390",
         x86_64_linux: "b3ffbc12689bfe81389d6577787fcea4cab81bd3b6bba9b719e73770b62d720e"

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
