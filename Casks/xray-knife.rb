cask "xray-knife" do
  arch arm: "arm64-v8a", intel: "64"

  version "11.4.0"
  sha256 arm:   "7918824d71e06e91dd5d64dff655049fba84765f2cf8ab21f0856e337bd32958",
         intel: "4d6ccd06c744470d9ac0cea3b62a93d8e956688fb209981dbea63f61ed8b27a3"

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
