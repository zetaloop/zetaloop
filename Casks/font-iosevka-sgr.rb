cask "font-iosevka-sgr" do
  version "34.8.1"
  sha256 "7b5bfccb0beb606d27fdfd26e89217362947727757f9e824facc7b6857734294"

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
