cask "font-iosevka-sgr-term" do
  version "34.8.0"
  sha256 "523adf9752e130961d0cdbb6e80d22d1d0cfdd575b34f55282df02a69ef5903f"

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
