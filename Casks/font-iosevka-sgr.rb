cask "font-iosevka-sgr" do
  version "34.9.0"
  sha256 "e0caa35f7c182c334d58dde28f5ef7356a935e3fc2c4c2b9abebacde993ba1c3"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-Iosevka-#{version}.zip"
  name "SGr Iosevka"
  desc "Curly-braced monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-Iosevka.ttc"
end
