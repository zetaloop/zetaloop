cask "xray-knife" do
  arch arm: "arm64-v8a", intel: "64"

  version "11.3.0"
  sha256 arm:   "1339fd4ad4e71a644499735fbc2795ac0719e22a15cf9a55eac4f1a17c9b6a33",
         intel: "1119d7b7585b04cdbcd47628beb8599a760f7a86c22d1b49389a625ad1a6a237"

  url "https://github.com/lilendian0x00/xray-knife/releases/download/v#{version}/Xray-knife-macos-#{arch}.zip"
  name "xray-knife"
  desc "Manage, test, and use Xray and sing-box proxy configurations"
  homepage "https://github.com/lilendian0x00/xray-knife"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "xray-knife"
end
