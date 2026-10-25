cask "font-iosevka-sgr" do
  version "34.9.1"
  sha256 "26cca021ea646d2610ccb4d22fbe629939fc391ba8757999d70234ba09d17b24"

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
