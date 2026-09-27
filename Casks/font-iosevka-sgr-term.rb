cask "font-iosevka-sgr-term" do
  version "34.9.0"
  sha256 "daba270fcf8c471bf7a3d27055e90dbe64ea11205d44f1ec1061892d089bbe92"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-IosevkaTerm-#{version}.zip"
  name "SGr Iosevka Term"
  desc "Terminal monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-IosevkaTerm.ttc"
end
