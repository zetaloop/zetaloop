cask "capa" do
  arch arm: "-arm64"

  version "9.4.0"
  sha256 arm:   "119964afc348c80fff93ad8830124a0c55630f179906acb796636c0f8d410672",
         intel: "4f45921c756e55dc912ff100ad46427ebb087b88ca6b493f50b015c11ed892e4"

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
