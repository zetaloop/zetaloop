cask "font-iosevka-sgr" do
  version "34.8.0"
  sha256 "f9278d3cc47ec4cb30b25d84e197fd5a702d7d37805548acebbb95e79063fe09"

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
