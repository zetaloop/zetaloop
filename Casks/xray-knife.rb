cask "xray-knife" do
  arch arm: "arm64-v8a", intel: "64"

  version "11.5.1"
  sha256 arm:   "3813e9717de8ab3b1a47dd99f025d68c1edd3e0eb645fc48909603afe0d89c8a",
         intel: "d28128c45ce5832050b03bbd721962345d6a3ef3c6daf7ebeb0b58523c822fad"

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
