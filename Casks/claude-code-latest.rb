cask "claude-code-latest" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.271"
  sha256 arm:          "87d119eb46782a1369d79d6e8cc00557f1b51bc9db7a51bd01fa2f909d8fe3dc",
         x86_64:       "98e796c311fd8c1d3ed40b408aff2aa48f8d2e19761fa98d3777187ad32fa9e5",
         arm64_linux:  "daecf0a2fdae57c1603a937b60ea3e69b97750be6bce93cca5664d05a5ef50f5",
         x86_64_linux: "5e7b6fc24d0e124f68e99a0641c47b662945c6d197d768d7ad7a72cbf1897f58"

  url "https://downloads.claude.ai/claude-code-releases/#{version}/#{os}-#{arch}/claude"
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
