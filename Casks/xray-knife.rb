cask "xray-knife" do
  arch arm: "arm64-v8a", intel: "64"

  version "11.4.1"
  sha256 arm:   "e154daecfaa13992d227296dd34daf6ee382d1866e7696858cc1862d20139b09",
         intel: "9b99c8c0ee8cfc131ed4e8bd811f660031153d11ae84b74ec6e59d42dc75c509"

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
