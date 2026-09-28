cask "flare-floss" do
  version "3.1.1"
  sha256 "1f272641485a70ad848d97ad4e5c89b69ae5a50b71e2e8f7b6ad650750af49d1"

  url "https://github.com/mandiant/flare-floss/releases/download/v#{version}/floss-v#{version}-macos.zip"
  name "FLOSS"
  desc "Automatically extract obfuscated strings from malware"
  homepage "https://github.com/mandiant/flare-floss"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "floss"
end
