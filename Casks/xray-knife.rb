cask "xray-knife" do
  arch arm: "arm64-v8a", intel: "64"

  version "11.5.0"
  sha256 arm:   "f7d72b3e86733cab818963571564537bfa6dccec96ceca45ebeefb78ff42f00d",
         intel: "1726977df48cadea5fd692f2d20ff351639759c7959608cf956a32418ea0d9f5"

  url "https://github.com/lilendian0x00/xray-knife/releases/download/v#{version}/Xray-knife-macos-#{arch}.zip"
  name "xray-knife"
  desc "Manage, test, and use Xray and sing-box proxy configurations"
  homepage "https://github.com/lilendian0x00/xray-knife"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "xray-knife"
end
