cask "capa" do
  arch arm: "-arm64"

  version "10.0.0"
  sha256 arm:   "04a827aef9517da045403da6927721c6489263a4a7e3846cc7da05f745062b73",
         intel: "566617317a46a7c7c215a2004d55cf0175a0a9ec31419dfeb6a0b4c2aff8b5da"

  url "https://github.com/mandiant/capa/releases/download/v#{version}/capa-v#{version}-macos#{arch}.zip"
  name "capa"
  desc "Identify capabilities in executable files"
  homepage "https://github.com/mandiant/capa"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "capa"
end
