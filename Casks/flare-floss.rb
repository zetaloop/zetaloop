cask "flare-floss" do
  version "3.2.0"
  sha256 "dda11c1e07694b5eb9a9587f6c32dee01cc032376657e6d597f6f95cc0ed9c61"

  url "https://github.com/mandiant/flare-floss/releases/download/v#{version}/floss-v#{version}-macos.zip"
  name "FLOSS"
  desc "Automatically extract obfuscated strings from malware"
  homepage "https://github.com/mandiant/flare-floss"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "floss"
end
